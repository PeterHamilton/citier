require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define do
  create_table :citier_classes do |t|
  end
  create_table :non_citier_classes do |t|
  end
end

class CitierClass < ActiveRecord::Base
  acts_as_citier
end

class NonCitierClass < ActiveRecord::Base
end

describe "Adding methods to ActiveRecord::Base with acts_as_citier" do

  it "sucessfully adds acts_as methods to active record" do
    citier_methods = Citier::Base::RequiredMethods.instance_methods
    active_record_methods = ActiveRecord::Base.methods

    citier_methods.each do |m|
      active_record_methods.include?(m).should eq(true)
    end
  end

  it "sucessfully adds class methods to classes which act as citier" do
    citier_methods = Citier::Base::ClassMethods.instance_methods
    active_record_methods = CitierClass.methods

    citier_methods.each do |m|
      active_record_methods.include?(m).should eq(true)
    end
  end

  it "sucessfully adds all citier instance methods to active record instances" do
    citier_methods = Citier::Base::InstanceMethods.instance_methods
    citierclass_methods = CitierClass.new.methods

    citier_methods.each do |m|
      citierclass_methods.include?(m).should eq(true)
    end
  end

  it "doesn't add citier class methods to non-citier classes" do
    citier_methods = Citier::Base::ClassMethods.instance_methods
    citierclass_methods = NonCitierClass.methods
    citierclass_methods.delete(:acts_as_citier?) # Should be in both

    citier_methods.each do |m|
      citierclass_methods.include?(m).should eq(false)
    end
  end

  it "doesn't add citier instance methods to non-citier instances" do
    citier_methods = Citier::Base::InstanceMethods.instance_methods
    citierclass_methods = NonCitierClass.new.methods

    citier_methods.each do |m|
      citierclass_methods.include?(m).should eq(false)
    end
  end
end

describe "identifying citier vs non citier classes" do

  it "identifies an acts_as_citier class" do
    CitierClass.acts_as_citier?.should eq(true)
  end

  it "identifies a non acts_as_citier class" do
    NonCitierClass.acts_as_citier?.should eq(false)
  end
end
