package Test;

import org.openqa.selenium.By;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.ui.Select;

public class Executor extends Navigator
{

	
public static void enterValues() {
		
		WebElement make=driver.findElement(By.xpath("//select[@id='make']"));
		WebElement enginePerformance=driver.findElement(By.xpath("//input[@id='engineperformance']"));
		
		WebElement dateOfManufacture=driver.findElement(By.xpath("//input[@id='dateofmanufacture']"));
		WebElement numberOfSeats=driver.findElement(By.xpath("//select[@id='numberofseats']"));		
		WebElement fuelType=driver.findElement(By.xpath("//select[@id='fuel']"));		
		WebElement listPrice=driver.findElement(By.xpath("//input[@id='listprice']"));		
		WebElement plateNumber=driver.findElement(By.xpath("//input[@id='licenseplatenumber']"));
		WebElement annualMileage=driver.findElement(By.xpath("//input[@id='annualmileage']"));
		WebElement rightHandDriver=driver.findElement(By.xpath("//input[@id='righthanddriveyes']"));
		WebElement numberOfMotorCycleSeats=driver.findElement(By.xpath("//select[@id='numberofseatsmotorcycle']"));
		WebElement payload=driver.findElement(By.xpath("//input[@id='payload']"));
		
		WebElement totalWeight=driver.findElement(By.xpath("//input[@id='totalweight']")); 
		WebElement nextButton=driver.findElement(By.xpath("//button[@id='nextenterinsurantdata']"));

		
		//enter Make
		select=new Select(make);
		select.selectByValue("Audi");
		System.out.println("Entered the field Make");
		//enter engine Performance
		enginePerformance.sendKeys("34");		
		System.out.println("enter engine Performance");
		
		
		//enter Date Of Manufacturer		
		dateOfManufacture.sendKeys("02/07/2020");
		System.out.println("enter Date Of Manufacturer");
		
		//enter Number of Seats
		select= new Select(numberOfSeats);
		select.selectByValue("1");
		System.out.println("Entered the number of seats");
		
		//select fuel Type
		select= new Select(fuelType);
		select.selectByValue("Petrol");
		System.out.println("Selected Petrol");
		
		//enter list price		
		listPrice.sendKeys("850");
		System.out.println("Entered list Price");
		
		//license PlateNumber
		plateNumber.sendKeys("1234");
		System.out.println("ENtered License Platenumber");
		
		//annual Milege
		
		annualMileage.sendKeys("134");
		System.out.println("Entered annual Mileage");
	
		
		
		//select number of motor cycle seats
		select= new Select(numberOfMotorCycleSeats);
		select.selectByValue("1");
		
		System.out.println("Selected Motor Cycle Seats");
		//enter payload
		payload.sendKeys("10");
		
		System.out.println("ENtered Payload");
		//enter total Weight
		totalWeight.sendKeys("200");
		
		System.out.println("Selected Total Weight");
		
		System.out.println("Entered all values");
		
		nextButton.click();
		System.out.println("Clicked on the next Button");
		
		
	}
}
