version 1.0

# Run CountKmers
#
# Count specified kmers in a SAM/BAM/CRAM file
#
#  Required Tool Arguments
#    fastaFile                 The FASTA to parse for "interesting" kmers
#    reads                     BAM/SAM/CRAM file containing reads
#    reference                 Reference FASTA (needed if reads is a CRAM)
#    prefix                    Prefix of file to hold output counts of the "interesting" kmers
#

workflow CountKmers {

  input {
    File fastaFile
    File reads
    File? reference
    File? refIdx
    File? refDict
    String prefix
  }

  call CountKmers {

    input:
        fastaFile   = fastaFile,
        reads       = reads,
        reference   = reference,
        refIdx      = refIdx,
        refDict     = refDict,
        prefix  = prefix
  }

  output {
    File counts = CountKmers.counts
  }
}

task CountKmers {

  input {
    File fastaFile
    File reads
    File? reference
    File? refIdx
    File? refDict
    String prefix
  }

  command <<<
    gatk CountKmers --fasta-file ~{fastaFile} -I ~{reads} ~{'-R ' + reference} -O ~{prefix}.counts
  >>>

  runtime {
      docker: "tedsharpe/count-kmers"
      memory: "4G"
      disks: "local-disk 40 HDD"
      cpu: "2"
      preemptible: "3"
      bootDiskSizeGb: "15"
  }

  output {
      File counts = "~{prefix}.counts"
  }
}

