# Generate the LAMMPS input script and data files necessary to run LAMMPS.

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
                -monomer-name 'DNAMonomer.scale(1,0.8,0.8)' \
                -header 'import "dna_monomer.lt"' \
                -padding 20,20,20 \
                < init_crds_polymer_backbone.raw > dna_polymer.lt

  # (Note: The "-helix" parameter represents the twist-per-monomer (Δφ) at the
  #        start of the simulation.  Example "genpoly_lt.py -helix 102.857 ...")


  # Now create the "wall".  (The container in which the polymer resides.)
  # The shape of this wall is determined by the "coords_wall.raw" file.
  # For each line in the "coords_wall.raw" file, create a "WallBead"
  # and put it at that X,Y,Z location using the "new move" command.
  # Save all these commands in the "boundary.lt".  Example contents:
  # import "wall_particle.lt"    #(defines "WallParticle")
  # wall_particles[0] = new WallParticle.move(-9.04656, 37.9741, -9.94262)
  # wall_particles[1] = new WallParticle.move(3.20814, -21.8542, 20.1384)
  # wall_particles[2] = new WallParticle.move(22.1283, 15.6168, 16.7046)
  # wall_particles[3] = new WallParticle.move(17.4089, 11.6577, -21.1946)
  #     :         :       :
  # (Awk provides an easy way to do make this file.)

  echo 'import "wall_particle.lt"  #(defines "WallParticle")' > wall.lt
  awk '{print "wall_particles["(NR-1)"]=new WallParticle.move("$1","$2","$3")\n"}' < coords_wall.raw >> wall.lt

  # (Moltemplate will read this file and put WallParticles at these locations.)


  # Finally, run moltemplate (on "system.lt").
  # ("system.lt" contains a reference to all the .LT files we created above.)

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
  rm -f wall.lt coords_wall.raw dna_polymer.lt init_crds_polymer_backbone.raw

cd ../
