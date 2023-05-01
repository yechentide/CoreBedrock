package main

import (
	"encoding/json"
	"fmt"
	"os"
	"sort"
	"strings"
)

const repoRootDirPath = "/Users/tide/Downloads/BedrockLab/repos/minecraft-data"

type Biome struct {
	ID            int32  `json:"id"`
	Name          string `json:"name"`
	CamelCaseName string `json:"-"`
}

type Block struct {
	ID            int32  `json:"id"`
	Name          string `json:"name"`
	Transparent   bool   `json:"transparent"`
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
	exportBlockTypeEnum()
	// exportBiomeTypeEnum()
}

func exportBlockTypeEnum() {
	blockJsonData, err := os.ReadFile(repoRootDirPath + "/data/bedrock/1.19.1/blocks.json")
	if err != nil {
		panic(err)
	}

	var blockList []Block
	json.Unmarshal(blockJsonData, &blockList)
	sort.Slice(blockList, func(i, j int) bool {
		return blockList[i].ID < blockList[j].ID
	})

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
	format03 := fmt.Sprintf("            case %%-%ds self = .%%s\n", camelCaseNameMaxLength+18)
	formatForColor := fmt.Sprintf("            case %%-%ds return %%s\n", camelCaseNameMaxLength+2)
	builder := strings.Builder{}

	// definition
	builder.WriteString("public enum MCBlockType: UInt32 {\n")
	for _, block := range blockList {
		builder.WriteString(fmt.Sprintf(format01, block.CamelCaseName, block.ID))
	}
	builder.WriteString("}\n")

	// to string
	builder.WriteString("\n")
	builder.WriteString("extension MCBlockType: CustomStringConvertible {\n")
	builder.WriteString("    public var description: String {\n")
	builder.WriteString("        switch self {\n")
	for _, block := range blockList {
		builder.WriteString(fmt.Sprintf(format02, "."+block.CamelCaseName+":", "minecraft:"+block.Name))
	}
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")
	builder.WriteString("}\n")

	// from string
	builder.WriteString("\n")
	builder.WriteString("extension MCBlockType: ExpressibleByStringLiteral {\n")
	builder.WriteString("    public init(stringLiteral value: String) {\n")
	builder.WriteString("        switch value {\n")
	for _, block := range blockList {
		builder.WriteString(fmt.Sprintf(format03, "\"minecraft:"+block.Name+"\":", block.CamelCaseName))
	}
	builder.WriteString("            default:                                                 self = .unknown\n")
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")
	builder.WriteString("}\n")

	// is opaque
	builder.WriteString("\n")
	builder.WriteString("extension MCBlockType {\n")
	builder.WriteString("    public var isOpaque: Bool {\n")
	builder.WriteString("        switch self {\n")
	for _, block := range blockList {
		if block.Transparent {
			continue
		}
		builder.WriteString(fmt.Sprintf(formatForColor, "."+block.CamelCaseName+":", "true"))
	}
	builder.WriteString(fmt.Sprintf(fmt.Sprintf("            %%-%ds return false\n", camelCaseNameMaxLength+7), "default:"))
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")
	builder.WriteString("}\n")

	// to color
	builder.WriteString("\n")
	builder.WriteString("extension MCBlockType {\n")
	builder.WriteString("    public var color: UInt32 {\n")
	builder.WriteString("        switch self {\n")
	for _, block := range blockList {
		builder.WriteString(fmt.Sprintf(formatForColor, "."+block.CamelCaseName+":", "0xF0000F"))
	}
	// builder.WriteString(fmt.Sprintf(formatForColor, "default", "0"))
	builder.WriteString(fmt.Sprintf(fmt.Sprintf("            %%-%ds return 0\n", camelCaseNameMaxLength+7), "default:"))
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")
	builder.WriteString("}")

	// output
	fmt.Println(builder.String())
}

func exportBiomeTypeEnum() {
	biomeJsonData, err := os.ReadFile(repoRootDirPath + "/data/bedrock/1.19.1/biomes.json")
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

	// definition
	builder.WriteString("public enum MCBiomeType: UInt16 {\n")
	builder.WriteString(fmt.Sprintf(format01, "unknown", 65535))
	for _, biome := range biomeList {
		builder.WriteString(fmt.Sprintf(format01, biome.CamelCaseName, biome.ID))
	}
	builder.WriteString("}\n")

	// to string
	builder.WriteString("\n")
	builder.WriteString("extension MCBiomeType: CustomStringConvertible {\n")
	builder.WriteString("    public var description: String {\n")
	builder.WriteString("        switch self {\n")
	builder.WriteString(fmt.Sprintf(format02, ".unknown:", "unknown"))
	for _, biome := range biomeList {
		builder.WriteString(fmt.Sprintf(format02, "."+biome.CamelCaseName+":", biome.Name))
	}
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")
	builder.WriteString("}\n")

	// from string
	builder.WriteString("\n")
	builder.WriteString("extension MCBiomeType: ExpressibleByStringLiteral {\n")
	builder.WriteString("    public init(stringLiteral value: String) {\n")
	builder.WriteString("        switch value {\n")
	for _, biome := range biomeList {
		builder.WriteString(fmt.Sprintf(format03, "\""+biome.CamelCaseName+"\":", biome.CamelCaseName))
	}
	builder.WriteString(fmt.Sprintf(fmt.Sprintf("            %%-%ds self = .unknown\n", camelCaseNameMaxLength+8), "default:"))
	builder.WriteString("        }\n")
	builder.WriteString("    }\n")
	builder.WriteString("}")

	// output
	fmt.Println(builder.String())
}
