'use strict'

// forward console.log to iOS wrapper for xcode log output
console.log = function(what) {
    window.webkit.messageHandlers.debugLog.postMessage("LOG: " + JSON.stringify(arguments));
};
console.info = function(what) {
    window.webkit.messageHandlers.debugLog.postMessage("INFO: " + JSON.stringify(arguments));
};
console.warn = function(what) {
    window.webkit.messageHandlers.debugLog.postMessage("WARN: " + JSON.stringify(arguments));
};
console.error = function(what) {
    window.webkit.messageHandlers.debugLog.postMessage("ERROR: " + JSON.stringify(arguments));
};

console.info("logging installed");
