#require File.expand_path("../../../lib/math/math_evaluate", __FILE__)
require 'spec_helper'

describe "math evalute" do
  before {@e = MathEvaluate::Expression}
  
  it "the params are equals the should be true" do
    @e.eql?('-2+2', '0').should be_true
    @e.eql?('-2', '-2').should be_true
    @e.eql?('2', '4/2').should be_true
  end

  it "the params are equals the should be true" do
    @e.eql?('6.2', '12.4/2').should be_true
  end

  it "the params are equals the should be true" do
    @e.eql?('3*3', '18/2').should be_true
  end

  it "the params are equals the should be true" do
    @e.eql?('2', '2').should be_true
  end

  it "the params are equals the should be true" do
    @e.eql?('6.2', '6.1 + 0.1').should be_true
  end

  describe "test with variavles" do
    it "have should evalulate equals exp as true" do
      options = {variables: ['x']}
      @e.eql?('x + 4/2', 'x + 2', options).should be_true
    end
    it "have should evalulate diff expressions as false" do
      options = {variables: ['x']}
      @e.eql?('x + 4', 'x + 2', options).should be_false
    end
  end

  describe 'wrong answers' do
    it "the params are not equals the should be false" do
      @e.eql?('1000', '100 + 0.0').should be_false
    end

    it "shoul return false if empty string is sent" do
      @e.eql?('', '100 + 0.0').should be_false
    end
  end

  describe 'show accept more the one answer separate by ;' do

    it "10;10 should be equal 10;10" do
      @e.eql_with_many_answers?('10;10', '10;10').should be_true
    end

    it "10+x;x+2*5 should be equal 10+x;x+2*5 " do
      options = {variables: ['x']}
      @e.eql_with_many_answers?('10+x;x+2*5', '10+x;x+2*5', options).should be_true
    end

    it "10+x;x+2*5 should not be equal 10+x;x+2*6 " do
      options = {variables: ['x'], cmas_order: true}
      @e.eql_with_many_answers?('10+x;x+2*5', '10+x;x+2*6', options).should be_false
    end

    it "10+x;x+2*15 should be equal x+2*15;10+x  not considering order" do
      options = {variables: ['x'], cmas_order: false}
      @e.eql_with_many_answers?('x+2*15;10+x', '10+x;x+2*15', options).should be_true
      #@e.eql_with_many_answers?('x+2*5;10+x', '10+x;x+2*6', options).should be_false
    end

    it "should be equal when cmas_order option is false" do
      options = {variables: [], cmas_order: false}
      @e.eql_with_many_answers?('10;20', '20;10', options).should be_true
      @e.eql_with_many_answers?('10;-20', '-20;10', options).should be_true
    end

    it "should be equal when cmas_order option is true" do
      options = {variables: [], cmas_order: false}
      @e.eql_with_many_answers?('10;-20', '-20;10', options).should be_true
      @e.eql_with_many_answers?('10;20', '10;20', options).should be_true
    end

    it "10;20 should be equal 10;20 and 20;10 when cmas_order option is false " do
      options = {variables: [], cmas_order: false}
      @e.eql_with_many_answers?('10;20', '20;10', options).should be_true
      @e.eql_with_many_answers?('10;20', '20;20', options).should be_false
    end

    it "should allow equal when cmas_order option is true " do
      options = {variables: [], cmas_order: true}
      @e.eql_with_many_answers?('10;10', '10;10', options).should be_true
      @e.eql_with_many_answers?('10;20', '20;10', options).should be_false
    end
  end

  describe 'show accept expression with = sinal' do
    it "a + 2 = 2 + a" do
      options = {variables: ['a']}
      @e.eql_with_eql_sinal?('a + 2 = 2 + a', '2 + a = a + 2', options).should be_true
    end
    it "a+2+b=2+b+a" do
      options = {variables: ['a','b']}
      @e.eql_with_eql_sinal?('a+2+b=2+b+a', 'a+2+b=2+b+a', options).should be_true
    end
    it "a^2=b^2+c^2" do
      options = {variables: ['a','b','c']}
      @e.eql_with_eql_sinal?('a^2=b^2+c^2', 'a^2=b^2+c^2', options).should be_true
      @e.eql_with_eql_sinal?('a^2=b^2+c^2', 'b^2+c^2=a^2', options).should be_true
    end
    it "a^(2) = 10^(2)+40^(2) should not be equal a^(2) = 10^(2)+40^(2)" do
      options = {variables: ['a']}
      @e.eql_with_eql_sinal?('a^(2) = 10^(2)+40^(2)', 'a = 10^(2)+40^(2)', options).should be_false
    end
  end

  describe "calculate with a precision" do
    it "should determinate equivalent with precision 1" do
      options = {precision: 1}

      @e.eql?('10.10', '10.10', options).should be_true
      @e.eql?('10.1234', '10.10', options).should be_true
    end

    it "should determinate equivalent with precision 1" do
      options = {precision: 2}

      @e.eql?('10.12', '10.1', options).should be_false
      @e.eql?('10.1234', '10.12', options).should be_true
    end
  end

end
