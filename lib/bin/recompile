#!/usr/bin/env node
"use strict";


/** Run from command-line */
if(typeof atom === "undefined"){
	require("child_process").exec(`cd ${__dirname} && atom -t ${process.argv[1]}`);
	process.exit();
}


/**
 * Exploit Atom's task-running mechanism to perform a recompilation from command-line.
 * Saves manually (re-)compiling CoffeeScript files when there's no need to.
 */
describe("Config recompilation", i => {
	it("writes the compiled icon-config to disk", i => require("../config").compile());
});
