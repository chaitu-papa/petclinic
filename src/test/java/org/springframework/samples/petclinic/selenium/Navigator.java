package Test;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
//import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.remote.DesiredCapabilities;
import org.openqa.selenium.support.ui.Select;
import org.openqa.selenium.htmlunit.HtmlUnitDriver;	

public class Navigator {
	static WebDriver driver;
	static Select select=null;
	public static void main(String[] args) throws InterruptedException {
		System.setProperty("webdriver.chrome.driver", System.getProperty("user.dir")+"//driver//chromedriver.exe");
		
		//DesiredCapabilities capabilities = DesiredCapabilities.chrome();
		//ChromeOptions options = new ChromeOptions();
		//options.addArguments("--start-maximized");
		//capabilities.setCapability(ChromeOptions.CAPABILITY, options);	
		//driver = new ChromeDriver(capabilities);
		WebDriver driver = new HtmlUnitDriver();
		driver.get("http://dev-spring-petclinic.devops-coe-cts.com/spring-petclinic");	
		System.out.println("Opened the page --> http://dev-spring-petclinic.devops-coe-cts.com/spring-petclinic");
		Thread.sleep(2000);
		Executor.enterValues();		
		driver.quit();		
		System.out.println("Closing Browser");		
		System.out.println("End of Test");
	}
	
	
	
	

}
