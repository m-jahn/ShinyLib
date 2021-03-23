helpbox <- function(width = 6) {
  column(width = width, 
    h4('INFO & HELP'),
    wellPanel(
      h4('HOW TO'),
      p('Use the tree to select subsets of genes and pathways.
        Not every button works as input for every plot, just play around.'),
      h4('DATA AND REFERENCES'),
      p('The CRISPRi library in Synechocystis was published as ',
        a(href = 'https://www.nature.com/articles/s41467-020-15491-7', target = '_blank', 'Yao et al., Nature Communications, 2020'), '.'
      ),
      p('The transposon mutant library paper for Cupriavidus necator is currently under revision. Preprint is available as ',
        a(href = 'https://www.biorxiv.org/content/10.1101/2021.03.21.436304v1', target = '_blank', 'Jahn et al., BioRxiv.org, 2021'), '.'
      ),
      p('The source code for this R shiny app is available at ', 
        a(href = 'https://github.com/m-jahn/ShinyLib', target = '_blank', 'github/m-jahn'), '.'
      ),
      h4('CONTACT'),
      p('For questions or reporting issues, contact Michael Jahn, Science 
        For Life Lab - Royal Technical University (KTH), Stockholm',
        a(href ='mailto:michael.jahn@scilifelab.se', target = '_blank', 'michael.jahn@scilifelab.se')
      )
    )
  )
}

fundbox <- function(width = 6) {
  column(width = width, 
    wellPanel(
      h4('FUNDING AND OTHER RESOURCES'),
      p('We gratefully acknowledge funding of this study by the following organisations:'),
      tags$ul(
        tags$li('Swedish Foundation For Strategic Research - SSF'), 
        tags$li('Swedish Research Council for Environment, 
          Agricultural Sciences and Spatial Planning - Formas')
      )#,
      #p(''),
      #fluidRow(img(src = '../formas_logo.png', width = '200px')),
      #p(''),
      #fluidRow(img(src = '../SSF_logo.png', width = '120px'))
    )
  )
}

methbox <- function(width = 6) {
  column(width = width,
    h4('METHOD DETAILS'),
    wellPanel(
      h4('The Synechocystis CRISPRi library'),
      p('We designed a CRISPRi respression library for the cyanobacterium Synechocystis sp. 
        PCC6803. The library is based on the inhibitory effect of the dCas9 gene and
        a corresponding short guide RNA (sgRNA) that conveys specificity to the enzyme.
        In each cell, the dCas9 enzyme will bind a unique sequence variant of the sgRNA.
        The dCas9-sgRNA complex then binds a region close to the promoter of the target gene 
        and will repress transcription by physically blocking RNA polymerase. By using a pool
        of thousands of different sgRNAs, transcription of all genes of a bacterial strain
        can be repressed, one at a time.
      '),
      h4('Details on sgRNA design'),
      p('Two sgRNAs were designed for each open reading frame (ORF) and 
        non-coding RNA in the Synechocystis genome (Reference genome NCBI NC_00091). 
        An in-house Python script was used to create protospacer sequences as close to 
        the transcription start site (TSS) or translation start codon (ATG) as possible, 
        within the following criteria: Target regions were required to be within 500 bp 
        from the known TSS or within 75% of total gene length, absence of G6 and T4, 
        and GC content between 25% and 75%. Target sequences were searched according to 
        the pattern 5’-CCN[20-25 bases])T-3’. The 5’-CCN ensured a 5’-NGG-3’ PAM site 
        on the coding strand, and 3’ T was to ensure binding of the 5’ end of the sgRNA, 
        known to have an A when transcribed from promoter PL22 in Synechocystis 
        (Huang et al., 2013). For each target fitting these criteria, 
        potential off-target regions in the genome were then identified. An off-target 
        binding site defined as having fewer than two mismatches in the PAM-proximal 
        17 bp region of the proposed sgRNA. Both NGG and NAG PAMs and both strands were 
        considered. Then all sgRNA candidates for a gene, the two sgRNAs with the least 
        off-targets were selected. If possible, sgRNAs were selected that were at 
        least 10 bp apart from each other.
      '),
      h4('Depletion/enrichment experiments'),
      p('The contribution to fitness of every mutant can be determined by growing
        the mutant library population under selective conditions and sample
        after defined time points. Mutants where repression of the target gene
        causes a phenotype will have lower growth rate and therefore lower fitness for a
        particular growth condition. The composition of the library is simply probed by 
        next generation sequencing.
      '),
      p('Here, the Synechocystis sgRNA library was cultivated in an 8-tube photobioreactor 
        (Multi-Cultivator MC-1000-OD, Photon System Instruments, Drasov, CZ). The system 
        was customized to perform turbidostat cultivation as described previously 
        (Jahn et al., 2018). Reactors (65 mL) were bubbled with 1% v/v CO2 in air at 
        2.5 mL/min, and light intensity was controlled by a computer program. The OD720nm 
        and OD680nm were measured every 15 min. The turbidity set point was OD720nm = 0.2 
        and 22 mL fresh BG-11 was added to dilute the culture once the set point was 
        exceeded. Anhydrotetrocycline inducer was added to 500 ng/uL to the culture to 
        induce dCas9 expression, and to the reserve BG-11 media used for dilution. For 
        LD cultures, the light regime (12 h light - 12 h dark) followed a sinusoidal 
        function with maximum light intensity at 300 µmol m-2 s-1 (L (t) = 300 ⋅ sin (π/43200⋅ t)
        where t = cultivation time in seconds). For turbidostat cultivations with added L-lactate, 
        light intensity was 100 µmol m-2 s-1 and either 100 mM sodium L-lactate or 100 mM NaCl was 
        added to the BG-11 before inoculation and medium pH was adjusted to 7.8. All turbidostat 
        cultivations described in this work were performed as 4 independent replicates.
      '),
      h4('Statistical analysis of NGS data'),
      p('All analyses related to the initial publication of this library were 
        performed using the R programming language and are documented in 
        R markdown notebooks available at https://m-jahn.github.io/. Sequencing data were 
        processed as follows: Different sequencing runs were merged into a single master table. 
        For simplicity, harvesting time points 12 and 30 days for the sodium chloride condition 
        (NACL) were re-labelled as 16 and 32 days to correspond to time points of all other samples. 
        This did not influence the calculation of generation time or fitness score, and was done 
        only to display these samples along with corresponding L-lactate samples. The R package 
        DESeq2 (Love et al., 2014) was used to determine fold changes between conditions as well as 
        significance metrics (multiple hypothesis adjusted p-value, Benjamini-Hochberg procedure). 
        Determination of fold change and significance was based on aggregating 4 independent biological 
        replicates for all cultivations. Gene-wise annotation was added based on Uniprot 
        (IDs, protein properties, GO terms) and CyanoBase (functional categories). Altogether 7,119 
        unique sgRNAs corresponding to 3,541 unique genes (without non-coding RNAs) were included in the 
        analysis.'),
      h4('Calculation of fitness scores'),
      p('The gradual, sgRNA-mediated depletion of clones from the library allows 
        estimation of the contribution to cellular fitness for each individual gene. 
        Here, we defined the fitness F of a mutant as the area under the curve (AUC) for log2 
        fold change sgRNA abundance (log2 FC) at a number of generations (ngen) since induction, 
        normalized by maximum generations.
      '),
      p('F = AUC (ngen, log 2FC) / max(ngen)
      '),
      p('Differential fitness between for example two (light) conditions L300, L100 
      was calculated as F = FL300-FL100.')
    ),
    wellPanel(
      h4('The Cupriavidus transposon knockout library'),
      p('We created a transposon knockout library in the lithoautotrophic model bacterium Cupriavidus 
        necator. The transposon library was conjugated from a recombinant E. coli strain; transposons
        will integrate randomly into the genome and in many cases knockout a gene by disrupting the ORF
        through a large insertion. This library is more advanced than previous transposon libraries
        because transposons are barcoded by a random 20 nucleotide sequence stretch. In order to 
        investigate fitness of knock out mutants, it is only necessary to sequence the 20 nt barcode
        instead of an entire fragmented genome.'),
      h4('Creation of barcoded C. necator transposon library'),
      p('The transposon library was prepared according to the RB-TnSeq workflow described in Wetmore
        et al., 2015. Briefly, C. necator H16 wild type was conjugated with an E. coli APA766 donor
        strain containing a barcoded transposon library. The strain is auxotrophic for DAP, the L-Lysin
        precursor 2,6-diamino-pimelate, to allow for counter selection. Cultures of E. coli 
        APA766 and C. necator H16 were prepared, cells were harvested by centrifugation, cell pelletes 
        were washed and then mixed and plated together on 25 cm x 25 cm large trays with LB agar 
        supplemented with 0.4 mM DAP. For conjugation, plates were incubated overnight at 30°C. 
        After conjugation, cells were harvested and plated again on selection plates with LB agar 
        supplemented with 100 µg/mL kanamycin, without DAP. After colonies of sufficient size appeared, 
        transformants were harvested, diluted to an appropriate cell density immediately frozen at -80°C.'),
      h4('Mapping of transposon mutants (TnSeq)'),
      p('To map barcodes to transposon insertion sites on the genome, the genomic DNA of the mutant library
        has to be fragmented, transposon containing fragments enriched, and sequenced using NG sequencing. 
        Briefly, DNA was extracted from a mutant library culture using a spin column extraction kit.
        Genomc DNA was fragmented into 300 bp fragments using an ME220 focused ultrasonicator (Covaris).
        Library preparation of gDNA fragments followed the protocol of the NEBNext Ultra II DNA Library 
        Prep Kit. An extra purification step using streptavidin beads in combination with a 30 cycle PCR 
        amplification with biotinylated primers was performed to enrich transposon containing fragments.
        The prepared gDNA amplicons were sequenced using a NextSeq 500/550 Mid Output Kit v2.5 150 Cycles
        (Illumina) run on a NextSeq 550 instrument. Reads containing barcodes and genomic DNA fragments 
        were mapped to the C. necator genome following the protocol from Wetmore et al., 2015. 
        The automatic pipeline for TnSeq data analysis is available at https://github.com/m-jahn/TnSeq-pipe.'),
      h4('Gene fitness analysis (BarSeq)'),
      p('Gene fitness can be determined from the depletion (lower frequency) or enrichment (higher frequency)
        of barcode reads for the respective knockout mutants. Amplification of the barcodes from genomic 
        DNA using standard PCR from isolated genomc DNA. Amplified DNA samples were then pooled 
        with 40 ng from up to 36 different samples, run on an agarose gel and the main band extracted from the
        gel. The barcode library was then diluted, denatured and sequenced using a NextSeq 500/550 High Output 
        Kit v2.5 (75 Cycles) (Illumina) run on a NextSeq 550 instrument. A pipeline from Wetmore et al. was 
        adapted to trim and filter reads, extract barcodes, and summarize read counts per barcode.
        Fitness score calculation based on the log fold change of read count per barcode over time was 
        implemented as an R script. The automatic pipeline for BarSeq analysis is available at 
        https://github.com/Asplund-Samuelsson/rebar.')
    )
  )
}

help_dotplot <- function() {
  tags$body(
    h4('About this page'),
    tags$ul(
      tags$li('This plots shows enrichment or depletion of transposon insertion or sgRNA repression mutants'),
      tags$li('Filter data by selecting genes of interest from the tree'),
      tags$li('Filter data by condition, induction, or time point'),
      tags$li('Choose other ways to group variables (change color coding) or
        "condition" the data (change panels)')
    )
  )
}

help_heatmap <- function() {
  tags$body(
    h4('About this page'),
    tags$ul(
      tags$li('This plots shows enrichment or depletion of mutants over time'),
      tags$li('Values from several sgRNAs or conditions per gene are averaged.'),
      tags$li('Filter data by selecting genes of interest from the tree'), 
      tags$li('Filter data by condition, induction, or time point')
    )
  )
}

help_fitness <- function() {
  tags$body(
    h4('About this page'),
    tags$ul(
      tags$li('This plots shows the average fitness score per gene/sgRNA'),
      tags$li('Fitness can only be plotted for one or two selected conditions'),
      tags$li('Only the latest time point is used, selecting others makes no difference'),
      tags$li('Filter data by selecting genes of interest from the tree'), 
      tags$li('Filter data by condition or induction')
    )
  )
}