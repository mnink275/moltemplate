# Use these commands to generate the LAMMPS input script and data file


# Create LAMMPS input files this way:
cd moltemplate_files

  # Use the "genpoly_lt.py" to generate a moltemplate file (.LT file)
  # describing the polymer you want to simulate.  You must specify the
  # name of the moltemplate object which will be used as the monomer subunit
  # in the final polymer (eg. "DNAMonomer"), as well as any bonds (or angles
  # or dihedrals) linking one monomer to the next monomer, as well as the
  # helical twist angle (if applicable).  All of the details regarding
  # the behaviour of the polymer are contained in the "dnamonomer.lt" file
  # which defines the "DNAMonomer" object, as well as a link to the file
  # which defines "DNAForceField" (which DNAMonomer uses).  For details, see:
  # https://github.com/jewettaij/moltemplate/blob/master/doc/doc_genpoly_lt.md

  genpoly_lt.py -helix 102.7797 \
                -bond Backbone a a \
                -bond Backbone b b \
                -dihedral MajorGroove b b a a 0 1 1 2 \
                -dihedral Torsion a a b b 1 0 0 1 \
                -polymer-name 'DNAPolymer' \
                -inherits 'DNAForceField'  \
                -monomer-name 'DNAMonomer' \
                -header 'import "dna_monomer.lt"' \
		-padding 20,20,20 \
                < init_crds_polymer_backbone.raw > dna_polymer.lt

  # (Note: The "-helix" parameter represents the twist-per-monomer (Δφ) at the
  #        start of the simulation.  Example "genpoly_lt.py -helix 102.857 ...")



  # Then run moltemplate on "system.lt".
  # (Note: "system.lt" contains a reference to the polymer file we created.)

  moltemplate.sh system.lt

  # This will generate various files with names ending in *.in* and *.data. 
  # These files are the input files directly read by LAMMPS.  Move them to 
  # the parent directory (or wherever you plan to run the simulation).
  mv -f system.in* system.data system.psf vmd_commands.tcl ../

  # Optional:
  # The "./output_ttree/" directory is full of temporary files generated by 
  # moltemplate. They can be useful for debugging, but are usually thrown away.
  rm -rf output_ttree/

  # Optional: Delete other temporary files:
  rm -f dna_polymer.lt init_crds_polymer_backbone.raw

cd ../

