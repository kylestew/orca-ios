import * as fs from './fs.js'
import * as path from './path.js'
import * as osc from './osc.js'
import * as electron from './electron.js'
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

// forward console.log to iOS wrapper for xcode log output
console.log = function(what) {
    window.webkit.messageHandlers.debugLog.postMessage("LOG: " + JSON.stringify(arguments));
};
console.warn = function(what) {
    window.webkit.messageHandlers.debugLog.postMessage("WARN: " + JSON.stringify(arguments));
};
console.error = function(what) {
    window.webkit.messageHandlers.debugLog.postMessage("ERROR: " + JSON.stringify(arguments));
};
