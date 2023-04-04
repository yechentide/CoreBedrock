package main

import (
	"encoding/json"
	"fmt"
	"os"
	"strings"
)

type Biome struct {
	ID            int32  `json:"id"`
	Name          string `json:"name"`
	CamelCaseName string `json:"-"`
}

type Block struct {
	ID            int32  `json:"id"`
	Name          string `json:"name"`
	CamelCaseName string `json:"-"`
}

func toCamelCase(str string) string {
	wordList := strings.Split(str, "_")
	for i := 1; i < len(wordList); i++ {
		wordList[i] = strings.ToUpper(wordList[i][:1]) + wordList[i][1:]
	}
	return strings.Join(wordList, "")
}

func main() {
	exportBlockEnum()
	exportBiomeEnum()
}

func exportBlockEnum() {
	blockJsonData, err := os.ReadFile("/Users/tide/Downloads/minecraft-data/data/bedrock/1.19.1/blocks.json")
	if err != nil {
		panic(err)
	}

	var blockList []Biome
	json.Unmarshal(blockJsonData, &blockList)

	camelCaseNameMaxLength := 0
	snakeNameMaxLength := 0

	for i := 0; i < len(blockList); i++ {
		blockList[i].CamelCaseName = toCamelCase(blockList[i].Name)
		if len(blockList[i].Name) > snakeNameMaxLength {
			snakeNameMaxLength = len(blockList[i].Name)
		}
		if len(blockList[i].CamelCaseName) > camelCaseNameMaxLength {
			camelCaseNameMaxLength = len(blockList[i].CamelCaseName)
		}
	}

	format01 := fmt.Sprintf("    case %%-%ds = %%d\n", camelCaseNameMaxLength)
	format02 := fmt.Sprintf("            case %%-%ds return \"%%s\"\n", camelCaseNameMaxLength+2)
	format03 := fmt.Sprintf("            case %%-%ds self = .%%s\n", camelCaseNameMaxLength+3)

	builder := strings.Builder{}
	builder.WriteString("enum MCBlock: UInt32, ExpressibleByStringLiteral, CustomStringConvertible {\n")
	for _, biome := range blockList {
		builder.WriteString(fmt.Sprintf(format01, biome.CamelCaseName, biome.ID))
	}

	builder.WriteString("\n")
	builder.WriteString("    var description: String {\n")
	builder.WriteString("        switch self {\n")
	builder.WriteString("            case .unknown: return \"unknown\"\n")
	for _, biome := range blockList {
		builder.WriteString(fmt.Sprintf(format02, "."+biome.CamelCaseName+":", biome.Name))
	}
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")

	builder.WriteString("\n")
	builder.WriteString("    init(stringLiteral value: String) {\n")
	builder.WriteString("        switch value {\n")
	for _, biome := range blockList {
		builder.WriteString(fmt.Sprintf(format03, "\""+biome.CamelCaseName+"\":", biome.CamelCaseName))
	}
	builder.WriteString("            default: self = .unknown\n")
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")

	builder.WriteString("}\n\n\n")
	fmt.Println(builder.String())
}

func exportBiomeEnum() {
	biomeJsonData, err := os.ReadFile("/Users/tide/Downloads/minecraft-data/data/bedrock/1.19.1/biomes.json")
	if err != nil {
		panic(err)
	}

	var biomeList []Biome
	json.Unmarshal(biomeJsonData, &biomeList)

	camelCaseNameMaxLength := 0
	snakeNameMaxLength := 0

	for i := 0; i < len(biomeList); i++ {
		biomeList[i].CamelCaseName = toCamelCase(biomeList[i].Name)
		if len(biomeList[i].Name) > snakeNameMaxLength {
			snakeNameMaxLength = len(biomeList[i].Name)
		}
		if len(biomeList[i].CamelCaseName) > camelCaseNameMaxLength {
			camelCaseNameMaxLength = len(biomeList[i].CamelCaseName)
		}
	}

	format01 := fmt.Sprintf("    case %%-%ds = %%d\n", camelCaseNameMaxLength)
	format02 := fmt.Sprintf("            case %%-%ds return \"%%s\"\n", camelCaseNameMaxLength+2)
	format03 := fmt.Sprintf("            case %%-%ds self = .%%s\n", camelCaseNameMaxLength+3)

	builder := strings.Builder{}
	builder.WriteString("enum MCBiome: UInt16, ExpressibleByStringLiteral, CustomStringConvertible {\n")
	builder.WriteString("    case unknown = 65535\n")
	for _, biome := range biomeList {
		builder.WriteString(fmt.Sprintf(format01, biome.CamelCaseName, biome.ID))
	}

	builder.WriteString("\n")
	builder.WriteString("    var description: String {\n")
	builder.WriteString("        switch self {\n")
	builder.WriteString("            case .unknown: return \"unknown\"\n")
	for _, biome := range biomeList {
		builder.WriteString(fmt.Sprintf(format02, "."+biome.CamelCaseName+":", biome.Name))
	}
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")

	builder.WriteString("\n")
	builder.WriteString("    init(stringLiteral value: String) {\n")
	builder.WriteString("        switch value {\n")
	for _, biome := range biomeList {
		builder.WriteString(fmt.Sprintf(format03, "\""+biome.CamelCaseName+"\":", biome.CamelCaseName))
	}
	builder.WriteString("            default: self = .unknown\n")
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")

	builder.WriteString("}\n\n\n")
	fmt.Println(builder.String())
}
