RSpec.describe String do
  it do
    expect("test".red).to eq("\e[31mtest\e[0m")
  end
  
  it do
    expect("test".blue).to eq("\e[34mtest\e[0m")
  end

  it do
    expect("test".grey).to eq("\e[37mtest\e[0m")
  end
end