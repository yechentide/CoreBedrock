
// https://minecraft.fandom.com/wiki/Biome#Bedrock_Edition

// NOTE: add id to the biome table elements in the HTML

const javaBiomesTable = document.getElementById("java-biomes");
const bedrockBiomesTable = document.getElementById("bedrock-biomes");

const javaBiomeRows = javaBiomesTable.querySelectorAll("tbody tr");
const javaBiomeMap = {}
javaBiomeRows.forEach((row) => {
  const cells = row.querySelectorAll("td");
  const biomeName = cells[0].textContent.trim();
  const stringId = cells[1].textContent.trim();
  javaBiomeMap[biomeName] = stringId;
})

const bedrockBiomeRows = bedrockBiomesTable.querySelectorAll("tbody tr");
const bedrockBiomeMap = {}
let maxId = 0
bedrockBiomeRows.forEach((row) => {
  const cells = row.querySelectorAll("td");
  const biomeName = cells[0].textContent.trim();
  const stringId = cells[1].textContent.trim();
  const numberId = parseInt(cells[2].textContent.trim());
  if (numberId > maxId) {
    maxId = numberId;
  }
  const javaStringId = javaBiomeMap[biomeName] || "UNKNOWN";
  const line = `case ${stringId}      = ${numberId} // ${biomeName} (${javaStringId})\n`
  bedrockBiomeMap[numberId] = line;
})

let result = ""
for (let i = 0; i <= maxId; i++) {
  const line = bedrockBiomeMap[i]
  if (!!line) {
    result += line;
  }
}
console.log(result);
