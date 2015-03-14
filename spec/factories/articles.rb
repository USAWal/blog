FactoryGirl.define do
  factory :article do
    sequence :title do |index|
      "Article example \##{index}"
    end

    body <<-BODY
 Heading
 =======
 
 Sub-heading
 -----------
 
 ### Another deeper heading
 
 Paragraphs are separated
 by a blank line.
 
 Let 2 spaces at the end of a line to do a  
 line break
 
 Text attributes *italic*, **bold**,
 `monospace`, ~~strikethrough~~ .
 
 A [link](http://example.com).
 <<<   No space between ] and (  >>>

 Shopping list:
 
   * apples
   * oranges
   * pears
 
 Numbered list:
 
   1. apples
   2. oranges
   3. pears
 
 The rain---not the reign---in
 Spain.
 BODY

    factory :commented_article do
      transient do
        comments_count 5
      end

      after :create do |article, evaluator|
        create_list :queued_comment, evaluator.comments_count, article: article
      end
    end
  end
end
