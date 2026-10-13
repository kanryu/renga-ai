package main

import (
	"fmt"
	"os"
)

const version = "0.1.0-dev"

func main() {
	if len(os.Args) == 1 {
		printUsage()
		return
	}

	switch os.Args[1] {
	case "help", "-h", "--help":
		printUsage()
	case "version", "--version":
		fmt.Println("renga", version)
	default:
		fmt.Fprintf(os.Stderr, "renga: unknown command %q\n\n", os.Args[1])
		printUsage()
		os.Exit(2)
	}
}

func printUsage() {
	fmt.Println("Usage: renga <command> [arguments]")
	fmt.Println()
	fmt.Println("Renga project and workflow companion command.")
	fmt.Println()
	fmt.Println("Commands:")
	fmt.Println("  init       Create a Renga project")
	fmt.Println("  workflow   Inspect and validate workflows")
	fmt.Println("  run        Run a project workflow")
	fmt.Println("  package    Package a project or plugin")
	fmt.Println("  version    Print the Renga version")
}
