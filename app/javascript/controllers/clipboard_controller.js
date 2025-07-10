import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "button"]
  
  copy() {
    const content = this.contentTarget.innerText || this.contentTarget.value
    
    navigator.clipboard.writeText(content)
      .then(() => {
        // 버튼 내부의 span 요소 찾기
        const textSpan = this.buttonTarget.querySelector('span[data-clipboard-success-text]')
        const originalText = textSpan ? textSpan.innerText : this.buttonTarget.innerText
        const successText = textSpan ? textSpan.dataset.clipboardSuccessText : "✓ 복사됨!"
        
        if (textSpan) {
          textSpan.innerText = successText
        } else {
          this.buttonTarget.innerText = successText
        }
        
        // 그라데이션 클래스 업데이트
        this.buttonTarget.classList.remove("from-emerald-600", "to-emerald-700", "hover:from-emerald-700", "hover:to-emerald-800")
        this.buttonTarget.classList.add("from-green-600", "to-green-700", "hover:from-green-700", "hover:to-green-800")
        
        setTimeout(() => {
          if (textSpan) {
            textSpan.innerText = originalText
          } else {
            this.buttonTarget.innerText = originalText
          }
          
          this.buttonTarget.classList.remove("from-green-600", "to-green-700", "hover:from-green-700", "hover:to-green-800")
          this.buttonTarget.classList.add("from-emerald-600", "to-emerald-700", "hover:from-emerald-700", "hover:to-emerald-800")
        }, 2000)
      })
      .catch(err => {
        console.error('복사 실패:', err)
        
        // 더 나은 오류 처리
        const textSpan = this.buttonTarget.querySelector('span[data-clipboard-success-text]')
        const originalText = textSpan ? textSpan.innerText : this.buttonTarget.innerText
        
        if (textSpan) {
          textSpan.innerText = "❌ 복사 실패"
        } else {
          this.buttonTarget.innerText = "❌ 복사 실패"
        }
        
        this.buttonTarget.classList.remove("from-emerald-600", "to-emerald-700")
        this.buttonTarget.classList.add("from-red-600", "to-red-700")
        
        setTimeout(() => {
          if (textSpan) {
            textSpan.innerText = originalText
          } else {
            this.buttonTarget.innerText = originalText
          }
          
          this.buttonTarget.classList.remove("from-red-600", "to-red-700")
          this.buttonTarget.classList.add("from-emerald-600", "to-emerald-700")
        }, 2000)
      })
  }
}