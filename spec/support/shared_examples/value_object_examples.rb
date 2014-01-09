shared_examples "value object" do

  it { should ===(subject.dup) }
  it { should eql(subject.dup) }
  it { should ==(subject.dup) }
  it { should eq(subject.dup) }
  its(:hash) { should eq(subject.dup.hash) }

end
