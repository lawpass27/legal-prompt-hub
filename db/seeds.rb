# 테스트 사용자 생성
user = User.create!(
  email: "lawpass2727@gmail.com",
  password: "cleann1027!",
  name: "테스트 변호사"
)

# 샘플 프롬프트 생성
prompts = [
  {
    title: "계약서 당사자 분석 프롬프트",
    category: "party_analysis",
    content: "다음 계약서를 분석하여 당사자들의 정보를 정리해주세요:\n\n1. 각 당사자의 명칭과 역할\n2. 당사자들의 주요 권리\n3. 당사자들의 주요 의무\n4. 특별한 지위나 조건\n\n[계약서 내용을 여기에 붙여넣으세요]"
  },
  {
    title: "사실관계 시간순 정리",
    category: "fact_organizing",
    content: "다음 사실관계를 시간순으로 정리해주세요:\n\n1. 날짜별로 중요 사건 정리\n2. 각 사건의 법적 의미\n3. 인과관계 표시\n\n[사실관계를 여기에 입력하세요]"
  },
  {
    title: "판례 검색 키워드 추출",
    category: "keyword_extraction",
    content: "다음 사안에서 판례 검색에 사용할 핵심 키워드를 추출해주세요:\n\n1. 법적 쟁점 키워드 (5개)\n2. 사실관계 키워드 (5개)\n3. 검색 조합 제안\n\n[사안을 설명해주세요]"
  }
]

prompts.each do |prompt_data|
  user.legal_prompts.create!(prompt_data)
end

puts "시드 데이터 생성 완료!"
puts "테스트 계정: lawpass2727@gmail.com / cleann1027!"