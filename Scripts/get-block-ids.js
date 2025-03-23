/**
 * Extract block ids from wiki
 * 
 * - https://minecraft.fandom.com/wiki/Bedrock_Edition_data_values
 * - https://minecraft.fandom.com/ja/wiki/データ値/Bedrock_Edition#ブロック_ID
 * - https://minecraft.fandom.com/zh/wiki/基岩版数据值
 */

const findTables = (lastHeaderCellText) => {
  const targetTables = []
  const allTables = document.querySelectorAll("table")
  allTables.forEach((table) => {
    const header = table.querySelectorAll(":scope > tbody > tr")[0]
    const headerCells = header.querySelectorAll(":scope > th")
    if (headerCells.length === 0) {
      return
    }
    const lastCellText = headerCells[headerCells.length - 1].textContent
    if (lastCellText.startsWith(lastHeaderCellText)) {
      console.log(headerCells.length)
      targetTables.push(table)
    }
  })
  return targetTables
}

const extractBlockIdsFromTable = (table) => {
  const result = {
    blockCount: 0,
    idListString: "",
  }
  const rows = table.querySelectorAll("tr")
  const rowsWithoutHeader = Array.from(rows).slice(1)
  rowsWithoutHeader.forEach((row) => {
    const cells = row.querySelectorAll("td")
    if (cells[3] === undefined) {
      console.log(cells)
      return
    }
    const blockId = cells[3].textContent.trim()
    result.blockCount += 1
    result.idListString += `${blockId}\n`
  })
  return result
}

const getBlockIds = () => {
  const result = {
    blockCount: 0,
    idListString: "",
  }
  let lastHeaderCellText = "Block"
  if (window.location.href.includes("/ja/")) {
    lastHeaderCellText = "ブロック"
  } else if (window.location.href.includes("/zh/")) {
    lastHeaderCellText = "方块"
  }
  const targetTables = findTables(lastHeaderCellText)
  targetTables.forEach((table) => {
    const tableResult = extractBlockIdsFromTable(table)
    result.blockCount += tableResult.blockCount
    result.idListString += `${tableResult.idListString}\n`
  })
  console.log(result.idListString)
  console.log(result.blockCount)
}

getBlockIds()
