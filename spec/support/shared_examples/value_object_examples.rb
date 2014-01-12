shared_examples "value object" do

  it { should ===(subject.clone) }
  it { should eql(subject.clone) }
  it { should ==(subject.clone) }
  it { should eq(subject.clone) }
  its(:hash) { should eq(subject.clone.hash) }
  its(:frozen?) { should be_true }

end
