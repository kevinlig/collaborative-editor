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

var existingCursors = {};

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

    bridge.registerHandler("updateCursor", function(updateData) {
        // check if cursor exists
        var cursor;
        var cursorRange = new Range(updateData.cursor.row, updateData.cursor.col, updateData.cursor.row, updateData.cursor.col + 1);

        if (existingCursors['cursor' + updateData.priority] != undefined) {
            // cursor exists
            cursor = existingCursors['cursor' + updateData.priority];
            editor.session.removeMarker(cursor);
        }
        
        // make the cursor
        cursor = editor.session.addMarker(cursorRange, "bar", true);
    

        existingCursors['cursor' + updateData.priority] = cursor;
    });

    editorNativeCallbacks(bridge);


 


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