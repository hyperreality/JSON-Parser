JSON Parser
-----------
Validates JSON files according to the [ECMA-404 2013 JSON standard](http://www.ecma-international.org/publications/files/ECMA-ST/ECMA-404.pdf) using the [JFlex Scanner](http://www.jflex.de/) and [CUP Parser](http://www2.cs.tum.edu/projects/cup/) generators.

Installation
------------

Build using Apache Ant: `ant jar` - the jar file will be output to jar/Compiler.jar

Usage: `java -jar jar/Compiler.jar INPUTFILE.json`

If run on a valid file, the validator reports: "This is a valid JSON file". Otherwise, it reports the requisite syntax error and exits with exit code 1.

Testing
-------
The file testRunner.sh is a bash script that runs the compiler over a variety of JSON files in the testfiles/ directory. Most of these tests come from the official JSON website (http://www.json.org/JSON_checker/) and are sorted into tests that are expected to fail and tests that are expected to pass.

As the compiler is setup to exit with an error code of 1 when encountering a syntax error, and 0 otherwise, testRunner.sh reads this and uses it to give a total count of passed and failed tests.

testResults.txt contains the output of testRunner.sh, obtained by running `./testRunner.sh > testResults.txt`.


Process
-------
First I read through the JSON specification and translated all of the individual rules into Regex expressions for the lexer. This process is documented in comments in Scanner.jflex. For instance, 

    "A JSON char [can be] \u four-hex-digits"
    becomes
    \\u[0-9A-Fa-f]{4}

By combining these shorter rules into larger expressions, constructing correct rules for detecting character and number tokens - as well as other terminals in the JSON format - is straightforward. These terminals are then output to the CUP parser, whose configuration file defines non-terminals to allow nesting of data constructs. 

Note that in the old RFC-4627 JSON specification [the outermost construct could only be an object or an array](http://stackoverflow.com/questions/18419428/what-is-the-minimum-valid-json
value), whereas in later specifications any value is allowed.

Further documentation can be found in the Scanner.jflex and Parser.cup files.
