function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function() {
            callback(WebViewJavascriptBridge)
        }, false)
    }
}

var documentLoadEvent = false;

var editorMode = "";

var existingCursors = {};
var existingSelections = {};

connectWebViewJavascriptBridge(function(bridge) {

    /* Init your app here */
    bridge.init(function(data, responseCallback) {
        responseCallback(data);
    });

    // set up a handler to receive full documents
    bridge.registerHandler("pushFullDocument", function(data) {
        // received full document, replace the editor text with the data
        documentLoadEvent = true;
        editor.setValue(data);
        editor.selection.moveCursorTo(0,0);
        editor.selection.clearSelection();

        documentLoadEvent = false;
    });

    bridge.registerHandler("changeSyntax", function(syntaxString) {
        editor.getSession().setMode(syntaxString);
    });

    bridge.registerHandler("updateCursor", function(updateArray) {
        
        for (var i = 0; i < updateArray.length; i++) {
            var userState = updateArray[i];
            var userId = userState['user'];
            var userCursor = userState['state'];

            displayUserCursors(userCursor, userId);
        }
        
    });

    editorNativeCallbacks(bridge);


    bridge.registerHandler("toggleVim", function() {
        if (editorMode != "vim") {
            editor.setKeyboardHandler("");
            editor.setKeyboardHandler("ace/keyboard/vim");
            editorMode = "vim";
        }
        else {
            editor.setKeyboardHandler("");
            editorMode = "";
        }
    });

    bridge.registerHandler("toggleEmacs", function() {
        if (editorMode != "emacs") {
            editor.setKeyboardHandler("");
            editor.setKeyboardHandler("ace/keyboard/emacs");
            editorMode = "emacs";
        }
        else {
            editor.setKeyboardHandler("");
            editorMode = "";
        }
    });

    // okay, we're ready to go, let the native side know
    bridge.callHandler("jsReady");
});

// set up event callbacks
function editorNativeCallbacks(bridge) {
    editor.selection.on("changeCursor",function() {
        if (documentLoadEvent == false) {
            
            var cursor = editor.selection.getCursor();
            var range = editor.selection.getRange();

            var rangeStart = {"col":range.start.column, "row": range.start.row};
            var rangeEnd = {"col":range.end.column, "row": range.end.row}

            var nativeData = {"cursor": {"col": cursor.column, "row": cursor.row}, "selection": {"empty": editor.selection.isEmpty(), "start": rangeStart, "end": rangeEnd}};
            bridge.callHandler("changeCursor",nativeData);
        }
    });
}


function displayUserCursors(cursorData, userId) {
    // check if cursor exists
    var cursor;
    var cursorRange = new Range(cursorData.cursor.row, cursorData.cursor.col, cursorData.cursor.row, cursorData.cursor.col + 1);

    var selectionCursor;
    var selectionRange;

    var selection = false;
    if (cursorData.selection.empty == false) {
        selectionRange = new Range(cursorData.selection.start.row, cursorData.selection.start.col, cursorData.selection.end.row, cursorData.selection.end.col);
        cursorRange = new Range(cursorData.selection.start.row, cursorData.selection.start.col, cursorData.selection.start.row, cursorData.selection.start.col + 1);
        selection = true;
    }

    if (existingCursors['cursor' + userId] != undefined) {
        // cursor exists
        cursor = existingCursors['cursor' + userId];
        editor.session.removeMarker(cursor);
    }

    if (existingSelections['selection' + userId] != undefined) {
        // selection exists
        selectionCursor = existingSelections['selection' + userId];
        editor.session.removeMarker(selectionCursor);
    }
    
    // make the cursor
    cursor = editor.session.addMarker(cursorRange, "remoteCursor user" + userId, true);
    existingCursors['cursor' + userId] = cursor;

    // make the selection if necessary
    if (selection) {
        selectionCursor = editor.session.addMarker(selectionRange, "remoteSelection user" + userId, "line");
        existingSelections['selection' + userId] = selectionCursor;
    }

}

