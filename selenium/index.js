const fs = require('fs');
const XLSX = require('xlsx');
const { Builder, By, Key, until } = require('selenium-webdriver');

(async function main() {
	let driver = await new Builder().forBrowser("chrome").build();
	try {
		await driver.get("http://google.com");
		await driver.findElement(By.name("q")).sendKeys("Selenium", Key.ENTER)	
	} catch (e) {
        console.log(e);
    }
})()
