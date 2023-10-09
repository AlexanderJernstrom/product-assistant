import { Controller } from 'stimulus'

export default class extends Controller {
  connect () {
    console.log("this kinda works")
    super.connect()
  }

}
