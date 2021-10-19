//import dependencies
const puppeteer = require('puppeteer');

//fetch command line arguments
// Checks for --url and if it has a value
const urlIndex = process.argv.indexOf('--url');
let urlValue;

if (urlIndex > -1) {
  // Retrieve the value after --url
  urlValue = process.argv[urlIndex + 1];
}

// Checks for --headless and if it has a value -- FIX LATER
const headlessIndex = process.argv.indexOf('--headless');
let headlessValue;

if (headlessIndex > -1) {
  // Retrieve the value after --headless
  headlessValue = process.argv[headlessIndex + 1];
}

// Checks for --contrast-upload-file and if it has a value
const contrastUploadFileIndex = process.argv.indexOf('--contrast-upload-file');
let contrastUploadFileValue;

if (contrastUploadFileIndex > -1) {
  // Retrieve the value after --contrast-upload-file
  contrastUploadFileValue = process.argv[contrastUploadFileIndex + 1];
}

//declare variables for automation passed via arguments on the command line
const urlPage = urlValue;
const isHeadless = true; // headlessValue;
const launchArgs = ['--no-sandbox', '--disable-dev-shm-usage'];
const contrastUploadFile = contrastUploadFileValue;
const userAgent = 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36';
const submitElement = '#singleUploadForm > button';
const responseElement = '#singleFileUploadSuccess > p:nth-child(1)';

try {
    (async () => {
        // set some options (set headless to false so we can see 
        
        try {
          let launchOptions = { headless: isHeadless, args: launchArgs };
    
          const browser = await puppeteer.launch(launchOptions);
          const page = await browser.newPage();
    
          // set viewport and user agent (just in case for nice viewing)
          await page.setUserAgent(userAgent);
    
          // go to the target web
          await page.goto(urlPage);
    
          // get the ElementHandle of the selector above
          const inputUploadHandle = await page.$('input[type=file]');
    
          // prepare file to upload, I'm using contrast.jar file on same directory as this script
          let fileToUpload = contrastUploadFile;
    
          // Sets the value of the file input to fileToUpload
          inputUploadHandle.uploadFile(fileToUpload);
    
          // doing click on button to trigger upload file
          await page.evaluate(() => {
            document.getElementById('singleFileUploadInput').click();
          });

          //click submit
          await page.click(submitElement); 
            
          //close the browser
          await browser.close();
        } catch(err) {
          alert(err);
        }
    })();
} catch (error) {
    throw error;
}
