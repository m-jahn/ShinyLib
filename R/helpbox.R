helpbox <- function(width = 6) {
  column(width = width, 
    h4('INFO & HELP'),
    wellPanel(
      h4('HOW TO'),
      p('Just use the tree to select subsets of genes and pathways.
        Not every button works as input for every plot, just play around.'),
      h4('DATA AND REFERENCES'),
      p('The study presenting the underlying data for this app is currently under revision.'),
      p('The source code for this R shiny app is available on ', 
        a(href = 'https://github.com/m-jahn', target = '_blank', 'github/m-jahn')
      ),
      h4('CONTACT'),
      p('For questions or reporting issues, contact 
        Michael Jahn, Science For Life Lab - Royal Technical University (KTH), Stockholm'), 
      p(
        a(href ='mailto:michael.jahn@scilifelab.se', target = '_blank', 'email: Michael Jahn')
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
    )
  )
}

help_dotplot <- function() {
  tags$body(
    h4('About this page'),
    tags$ul(
      tags$li('This plots shows enrichment or depletion of two sgRNAs per gene over time (default)'),
      tags$li('Filter data by selecting genes of interest from the tree'), 
      tags$li('Filter data by condition, induction, or time point'),
      tags$li('You can also choose other ways to group variables (change color coding) or
        "condition" the data (change panels)'),
      tags$li('You can export results in three ways: save .png image directly by right
        clicking into the plot, save .svg vector graphic using the "Download" button, or
        save table for the selected conditions from the TABLE panel')
    )
  )
}

help_heatmap <- function() {
  tags$body(
    h4('About this page'),
    tags$ul(
      tags$li('This plots shows enrichment or depletion of genes over time'),
      tags$li('In contrast to a dot plot, values from several sgRNAs or conditions 
        per gene are averaged.'),
      tags$li('Use the "Grouping" option to change panel variables (default: induction)'),
      tags$li('Filter data by selecting genes of interest from the tree'), 
      tags$li('Filter data by condition, induction, or time point'),
      tags$li('You can export results in three ways: save .png image directly by right
        clicking into the plot, save .svg vector graphic using the "Download" button, or
        save table for the selected conditions from the TABLE panel')
    )
  )
}

help_fitness <- function() {
  tags$body(
    h4('About this page'),
    tags$ul(
      tags$li('This plots shows the average fitness score per sgRNA'),
      tags$li('Fitness can only be plotted for one, or for two conditions against each other'),
      tags$li('Fitness was calculated as area under the curve of log2 FC over cell generations 
        (normalized by number of generations). Selection of time points has no effect'),
      tags$li('The "Grouping" option has only limited functionality; grouping by condition is not allowed'),
      tags$li('Filter data by selecting genes of interest from the tree'), 
      tags$li('Filter data by condition or induction'),
      tags$li('You can export results in three ways: save .png image directly by right
        clicking into the plot, save .svg vector graphic using the "Download" button, or
        save table for the selected conditions from the TABLE panel')
    )
  )
}