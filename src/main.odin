package OdinPP

import "core:fmt"
import "core:os"
import "core:path/filepath"

import "ast"
import "parser"
import "printer"
import "tokenizer"

import ImRefl "../../Odin-ImReflect/imreflect"
import ImReflBs "../../Odin-ImReflect/imreflect/bootstrap"

main :: proc() {
	inputDir, outputDir: string

	for i := 1; i < len(os.args); i += 1 {
		switch arg := os.args[i]; arg {
		case "-i":
			i += 1
			inputDir = os.args[i]
		case "-o":
			i += 1
			outputDir = os.args[i]
		case:
			fmt.printfln(
				"Unknown flag \"%s\".\n\n\t\'-i\': Package Dir\n\n\t\'-o\': Output Dir\n",
				os.args[i],
			)
			return
		}
	}

	if !ImReflBs.init(500, 1000) {
		fmt.println("Error")
	}
	defer ImReflBs.shutdown()

	tokenizer.custom_keyword_tokens = {"class", "this"}
	pkg, ok := parser.collect_package(inputDir)
	if !ok {
		fmt.println("Failed to collect package!")
		return
	}

	if !parser.parse_package(pkg) {
		fmt.println("Failed to parse package!")
	}

	prtr := printer.make_printer(printer.default_style)
	for _, file in pkg.files {
		path, aerr := filepath.join({outputDir, filepath.base(file.fullpath)})
		if aerr != nil {
			fmt.println(aerr)
			return
		}
		output := printer.print(&prtr, file)
		defer delete(output)

		fp, ferr := os.create(fmt.tprintf("%s.odin", path))
		if ferr != nil {
			fmt.println(ferr)
			return
		}

		os.write(fp, transmute([]u8)output)
	}
}

