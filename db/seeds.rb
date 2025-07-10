# 테스트 사용자 생성
user = User.create!(
  email: "lawpass2727@gmail.com",
  password: "cleann1027!",
  name: "윤두철 변호사"
)

# 샘플 프롬프트 생성
prompts = [
  {
    title: "계약서 당사자 분석 프롬프트",
    category: "party_analysis",
    content: "다음 계약서를 분석하여 당사자들의 정보를 정리해주세요:\n\n1. 각 당사자의 명칭과 역할\n2. 당사자들의 주요 권리\n3. 당사자들의 주요 의무\n4. 특별한 지위나 조건\n\n[계약서 내용을 여기에 붙여넣으세요]",
    description: "복잡한 계약서에서 당사자들의 관계와 권리의무를 명확히 파악하기 위해 만든 프롬프트입니다.\n\n주요 활용 상황:\n- 다자간 계약서 검토 시\n- M&A 계약서 분석 시\n- 복잡한 거래구조 파악 시\n\n이 프롬프트는 각 당사자의 법적 지위, 권리, 의무를 체계적으로 정리하여 계약관계를 한눈에 파악할 수 있도록 도와줍니다."
  },
  {
    title: "사실관계 시간순 정리",
    category: "fact_organizing",
    content: "다음 사실관계를 시간순으로 정리해주세요:\n\n1. 날짜별로 중요 사건 정리\n2. 각 사건의 법적 의미\n3. 인과관계 표시\n\n[사실관계를 여기에 입력하세요]",
    description: "복잡한 사건의 전개 과정을 시간 순서대로 정리하여 인과관계를 명확히 파악하기 위한 프롬프트입니다.\n\n활용 예시:\n- 소송 준비서면 작성 시\n- 사건 경위서 작성 시\n- 분쟁 발생 원인 분석 시\n\nAI가 날짜와 사건을 자동으로 정렬하고, 각 사건 간의 연관성을 분석하여 법적 쟁점을 도출합니다."
  },
  {
    title: "판례 검색 키워드 추출",
    category: "keyword_extraction",
    content: "다음 사안에서 판례 검색에 사용할 핵심 키워드를 추출해주세요:\n\n1. 법적 쟁점 키워드 (5개)\n2. 사실관계 키워드 (5개)\n3. 검색 조합 제안\n\n[사안을 설명해주세요]",
    description: "효율적인 판례 검색을 위해 사안에서 핵심 키워드를 추출하는 프롬프트입니다.\n\n개발 배경:\n대법원 종합법률정보나 로앤비 등에서 판례 검색 시 적절한 키워드 선정이 검색 결과의 질을 좌우합니다.\n\n특징:\n- 법적 쟁점과 사실관계를 구분하여 키워드 추출\n- 유사 개념어와 관련 법조문도 함께 제시\n- 검색식 조합 방법 제안\n\n이를 통해 관련 판례를 빠르고 정확하게 찾을 수 있습니다."
  }
]

prompts.each_with_index do |prompt_data, index|
  prompt = user.legal_prompts.create!(prompt_data)
  
  # 태그 추가
  case index
  when 0
    prompt.tag_list = "계약서, 당사자분석, 민사"
  when 1
    prompt.tag_list = "사실관계, 정리, 소송"
  when 2
    prompt.tag_list = "판례검색, 키워드, 리서치"
  end
  
  prompt.save!
end

puts "시드 데이터 생성 완료!"
puts "테스트 계정: lawpass2727@gmail.com / cleann1027!"