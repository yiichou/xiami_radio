require 'uri'

en_url = "6hAFlm%F4jIcDph4%pLFZ4h1Et%mei21th46Wj%o2a2g1Fz2Mt23..FjKa2OPb5O5WiATZqEpF.xchq7GS3wcEa2SiFxLrJ%%fio%dGXiUYtipFxQ7Odk%32iam2TlRUGxjOzkRquHyQ5"

key = en_url[0].to_i
tmp_url = en_url[1..en_url.length]
fr = tmp_url.length.divmod(key)
ll = []
lu = []
bu = ""

key.times do |i|
  ll << (fr[1] > 0 ? fr[0] + 1 : fr[0])
  lu << tmp_url[0,ll[i]]
  tmp_url = tmp_url[ll[i]..tmp_url.length]
  fr[1] -= 1
end

ll[0].times do |i|
  lu.each do |piece|
    piece[i] && bu << piece[i] 
  end
end

URI.decode(bu).gsub("^","0")
