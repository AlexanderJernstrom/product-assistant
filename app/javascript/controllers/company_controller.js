import ApplicationController from './application_controller'

/* This is the custom StimulusReflex controller for the Company Reflex.
 * Learn more at: https://docs.stimulusreflex.com
 */
export default class extends ApplicationController {
  static targets = ["messageInput"]
  
  connect () {
    super.connect()
    console.log("hello world")
    // add your code here, if applicable
  }


  sendMessage(event) {
    console.log(event)
    this.messageInputTarget.value = "hello theer"
  }

 
}
