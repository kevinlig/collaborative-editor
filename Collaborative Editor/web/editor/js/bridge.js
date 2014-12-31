function connectWebViewJavascriptBridge(callback) {
    if (window.WebViewJavascriptBridge) {
        callback(WebViewJavascriptBridge)
    } else {
        document.addEventListener('WebViewJavascriptBridgeReady', function() {
            callback(WebViewJavascriptBridge)
        }, false)
    }
}

connectWebViewJavascriptBridge(function(bridge) {

    /* Init your app here */
    bridge.init(function(data, responseCallback) {
        responseCallback(data);
    });

    // set up a handler to receive full documents
    bridge.registerHandler("pushFullDocument", function(data) {
        // received full document, replace the editor text with the data
        // editor.setValue(atob(data));
        editor.setValue(data);
        editor.selection.moveCursorTo(0,0);
        editor.selection.clearSelection();
    });

    bridge.registerHandler("changeSyntax", function(syntaxString) {
        editor.getSession().setMode(syntaxString);
    });

    // okay, we're ready to go, let the native side know
    bridge.callHandler("jsReady");
});