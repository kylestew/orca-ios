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


//import * as electron from './electron.js'

// require() is a node thing and doesn't exist in the browser
// let's make a fake one, nothing can go wrong ;)
//window.mockRequire = function(name) {
//    switch (name) {
//////        case 'electron': return electron; break
//        default: console.warn('Failed to require ' + name);
//    }
//}


/*
import * as fs from './fs.js'
import * as path from './path.js'

import * as osc from './osc.js'
import * as dgram from './dgram.js'

import Buffer from './buffer.js'
window.Buffer = Buffer

window.require = function (what) {
  switch (what) {
    case 'dgram': return dgram; break
    case 'fs': return fs; break
    case 'path': return path; break
    case 'node-osc': return osc; break
    case 'electron': return electron; break
    default: console.log("missing mock - " + what); break
  }
}
*/
console.info("Electron mock installed");
