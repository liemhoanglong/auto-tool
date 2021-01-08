const fs = require('fs');
const XLSX = require('xlsx');
const { Builder, By, Key, until } = require('selenium-webdriver');
let temp ="Inserted successful :)";

(async function main() {
	console.log('===============> auto test chorme <================')
	let driver = await new Builder().forBrowser("chrome").build();
	const testData = `input.xlsx`;
	const testcases = await readTestCase(testData);
	// console.log(testcases)

	//output
	const writeStream = fs.createWriteStream("output.csv");
	const header = "Input,Expected result,Actual result,Status" + "\r\n";
	writeStream.write(header);

	//-----------------------------------------------------------------------------đăng nhập
	try {
		await driver.get("http://localhost:3000/admin-login.html");
		await driver.findElement(By.name("email")).sendKeys("longlin@gmail.com");
		await driver.findElement(By.name("password")).sendKeys("liemhoanglong", Key.ENTER);
		await driver.wait(until.elementLocated(By.css("#sidebar")), 7000, "ERROR: Page doesn't response");
		console.log('===============> Login success <================')
	} catch (e) {
		console.log(e);
	}
	//thêm gian hàng
	// for (let i = 0; i < 3; i++) {
	for (let i = 0; i < testcases.length; i++) {
		let j = i + 1;
		console.log('===============> Testcase ' + j + ' <================')
		let row;
		try {
			await driver.get("http://localhost:3000/admin-stall-add.html");
			await driver.findElement(By.name("name")).sendKeys(testcases[i].input, Key.ENTER);
			// #description > div > div > form > div.alert.alert-danger
			await driver.wait(until.elementLocated(By.css("#description > div > div > form > div.alert.alert-success")), 5000);
			let res = await driver.findElement(By.css("#description > div > div > form > div.alert.alert-success")).getText()
			console.log("========>Expected: "+testcases[i].expected)
			console.log("========>Actual:   "+res)
			if (testcases[i].expected === res) {
				console.log('Passed')
				row = testcases[i].input + "," + testcases[i].expected + "," + "Inserted successful :)" + "," + "Passed" + "\r\n";
			} else {
				console.log('Failed');
				row = testcases[i].input + "," + testcases[i].expected + "," + "Inserted successful :)" + "," + "Failed" + "\r\n";
			}
		} catch (e) {
			console.log("Expected: "+testcases[i].expected)
			console.log("Actual:   "+"You forget some fields :(")
			console.log('========>Passed');
			// #description > div > div > form > div.alert.alert-success
			// #description > div > div > form > div.alert.alert-danger
			row = testcases[i].input + "," + testcases[i].expected + "," + "You forget some fields :(" + "," + "Passed" + "\r\n";
		}
		writeStream.write(row);
	}
})()

const readTestCase = async (filename) => {
	const workbook = XLSX.readFile(filename);
	const sheetsNames = workbook.SheetNames;
	const sheet = workbook.Sheets[sheetsNames[0]];
	return XLSX.utils.sheet_to_json(sheet, {
		header: 0,
		defval: ""
	});
}