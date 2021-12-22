function wordtopairs(word) {
  n=split(word, chars, "")
  for (i = 1; i <= n; i++) {
    counts[chars[i]]++
  }
  for (i = 2; i <= n; i++) {
    key = chars[i-1] chars[i]
    print "key:" key
    numpairs[key]++
  }
}

function printpairs(some) {
  for (p in some) {
    print p ":" some[p]
  }
}

function dorule(text, pfrom, pto) {
  source = substr(pto, 1, 1) substr(pto, 3, 1)
  insertor = substr(pto, 2, 1)
  left = substr(pto, 1, 2)
  right = substr(pto, 2, 2)
  # print "source: " source " insertor:" insertor " left:" left " right:" right
  newpairs[left] += oldpairs[source]
  newpairs[right] += oldpairs[source]
  counts[insertor] += oldpairs[source]
}

function substrules_example(text) {
  text = dorule(text, "C#H", "CBH")
  text = dorule(text, "H#H", "HNH")
  text = dorule(text, "C#B", "CHB")
  text = dorule(text, "N#H", "NCH")
  text = dorule(text, "H#B", "HCB")
  text = dorule(text, "H#C", "HBC")
  text = dorule(text, "H#N", "HCN")
  text = dorule(text, "N#N", "NCN")
  text = dorule(text, "B#H", "BHH")
  text = dorule(text, "N#C", "NBC")
  text = dorule(text, "N#B", "NBB")
  text = dorule(text, "B#N", "BBN")
  text = dorule(text, "B#B", "BNB")
  text = dorule(text, "B#C", "BBC")
  text = dorule(text, "C#C", "CNC")
  text = dorule(text, "C#N", "CCN")
  return text
}

function substrules_problem(text) {
  text = dorule(text, "C#H", "CSH")
  text = dorule(text, "K#K", "KVK")
  text = dorule(text, "F#S", "FVS")
  text = dorule(text, "C#N", "CPN")
  text = dorule(text, "V#C", "VNC")
  text = dorule(text, "C#B", "CVB")
  text = dorule(text, "V#K", "VHK")
  text = dorule(text, "C#F", "CNF")
  text = dorule(text, "P#O", "POO")
  text = dorule(text, "K#C", "KSC")
  text = dorule(text, "H#C", "HPC")
  text = dorule(text, "P#P", "PBP")
  text = dorule(text, "K#O", "KBO")
  text = dorule(text, "B#K", "BPK")
  text = dorule(text, "B#H", "BNH")
  text = dorule(text, "C#C", "CNC")
  text = dorule(text, "P#C", "POC")
  text = dorule(text, "F#K", "FNK")
  text = dorule(text, "K#F", "KFF")
  text = dorule(text, "F#H", "FSH")
  text = dorule(text, "S#S", "SVS")
  text = dorule(text, "O#N", "OKN")
  text = dorule(text, "O#V", "OKV")
  text = dorule(text, "N#K", "NHK")
  text = dorule(text, "B#O", "BCO")
  text = dorule(text, "V#P", "VOP")
  text = dorule(text, "C#S", "CVS")
  text = dorule(text, "K#S", "KKS")
  text = dorule(text, "S#K", "SBK")
  text = dorule(text, "O#P", "OSP")
  text = dorule(text, "P#K", "PSK")
  text = dorule(text, "H#F", "HPF")
  text = dorule(text, "S#V", "SPV")
  text = dorule(text, "S#B", "SCB")
  text = dorule(text, "B#C", "BCC")
  text = dorule(text, "F#P", "FHP")
  text = dorule(text, "F#C", "FPC")
  text = dorule(text, "P#B", "PNB")
  text = dorule(text, "N#V", "NFV")
  text = dorule(text, "V#O", "VFO")
  text = dorule(text, "V#H", "VPH")
  text = dorule(text, "B#B", "BNB")
  text = dorule(text, "S#F", "SFF")
  text = dorule(text, "N#B", "NKB")
  text = dorule(text, "K#B", "KSB")
  text = dorule(text, "V#V", "VSV")
  text = dorule(text, "N#P", "NNP")
  text = dorule(text, "S#O", "SOO")
  text = dorule(text, "P#N", "PBN")
  text = dorule(text, "B#P", "BHP")
  text = dorule(text, "B#V", "BVV")
  text = dorule(text, "O#B", "OCB")
  text = dorule(text, "H#V", "HNV")
  text = dorule(text, "P#F", "PBF")
  text = dorule(text, "S#P", "SNP")
  text = dorule(text, "H#N", "HNN")
  text = dorule(text, "C#V", "CHV")
  text = dorule(text, "B#N", "BVN")
  text = dorule(text, "P#S", "PVS")
  text = dorule(text, "C#O", "CSO")
  text = dorule(text, "B#S", "BNS")
  text = dorule(text, "V#B", "VHB")
  text = dorule(text, "P#V", "PPV")
  text = dorule(text, "N#N", "NPN")
  text = dorule(text, "H#S", "HCS")
  text = dorule(text, "O#S", "OPS")
  text = dorule(text, "F#B", "FSB")
  text = dorule(text, "H#O", "HCO")
  text = dorule(text, "K#H", "KHH")
  text = dorule(text, "H#B", "HKB")
  text = dorule(text, "V#F", "VSF")
  text = dorule(text, "C#K", "CKK")
  text = dorule(text, "F#F", "FHF")
  text = dorule(text, "F#N", "FPN")
  text = dorule(text, "O#K", "OFK")
  text = dorule(text, "S#C", "SBC")
  text = dorule(text, "H#H", "HNH")
  text = dorule(text, "O#H", "OOH")
  text = dorule(text, "V#S", "VNS")
  text = dorule(text, "F#O", "FNO")
  text = dorule(text, "O#C", "OHC")
  text = dorule(text, "N#F", "NFF")
  text = dorule(text, "P#H", "PSH")
  text = dorule(text, "H#K", "HKK")
  text = dorule(text, "N#H", "NHH")
  text = dorule(text, "F#V", "FSV")
  text = dorule(text, "O#F", "OVF")
  text = dorule(text, "N#C", "NOC")
  text = dorule(text, "H#P", "HOP")
  text = dorule(text, "K#P", "KBP")
  text = dorule(text, "B#F", "BNF")
  text = dorule(text, "N#O", "NSO")
  text = dorule(text, "C#P", "CCP")
  text = dorule(text, "N#S", "NNS")
  text = dorule(text, "V#N", "VKN")
  text = dorule(text, "K#V", "KNV")
  text = dorule(text, "O#O", "OVO")
  text = dorule(text, "S#N", "SON")
  text = dorule(text, "K#N", "KCN")
  text = dorule(text, "S#H", "SFH")
  return text
}

function compute_answer() {
  for (c in counts) highest_c = counts[c]
  for (c in counts) lowest_c = counts[c]
  for (c in counts) {
    print c, counts[c]
    if (counts[c] > highest_c) highest_c = counts[c]
    if (counts[c] < lowest_c) lowest_c = counts[c]
  }
  print "highest:" highest_c " lowest:" lowest_c
  print "answer:" (highest_c - lowest_c)
  delete counts
}

BEGIN {
  delete counts
  word = "NNCB"
  print word
  delete numpairs
  wordtopairs(word)
  # printpairs(numpairs)
  delete oldpairs
  for (c in numpairs) oldpairs[c] = numpairs[c]
  for (step = 1; step <= 40; step++) {
    pairs = substrules_example(pairs)
    delete oldpairs
    for (c in newpairs) oldpairs[c] = newpairs[c]
    delete newpairs
  }
  printpairs(oldpairs)
  compute_answer()



  delete counts
  word = "BNBBNCFHHKOSCHBKKSHN"
  print word
  delete numpairs
  wordtopairs(word)
  # printpairs(numpairs)
  delete oldpairs
  for (c in numpairs) oldpairs[c] = numpairs[c]
  for (step = 1; step <= 40; step++) {
    pairs = substrules_problem(pairs)
    delete oldpairs
    for (c in newpairs) oldpairs[c] = newpairs[c]
    delete newpairs
  }
  printpairs(oldpairs)
  compute_answer()
}
