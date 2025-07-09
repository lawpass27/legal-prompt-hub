import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "button"]
  
  copy() {
    const content = this.contentTarget.innerText || this.contentTarget.value
    
    navigator.clipboard.writeText(content)
      .then(() => {
        const originalText = this.buttonTarget.innerText
        this.buttonTarget.innerText = "✓ 복사됨!"
        this.buttonTarget.classList.add("bg-green-600")
        this.buttonTarget.classList.remove("bg-emerald-600")
        
        setTimeout(() => {
          this.buttonTarget.innerText = originalText
          this.buttonTarget.classList.remove("bg-green-600")
          this.buttonTarget.classList.add("bg-emerald-600")
        }, 2000)
      })
      .catch(err => {
        console.error('복사 실패:', err)
        alert('복사에 실패했습니다. 텍스트를 직접 선택해주세요.')
      })
  }
}