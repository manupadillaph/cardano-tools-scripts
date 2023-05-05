# Loop over the plutus-apps-vX directories
folder=/home/manuelpadilla/source/tools
cd ${folder}
mkdir tmp-plutus-apps
for dir in plutus-apps*; do
  # Move the plutus-apps directory to the parent directory and rename it
  echo "Moving $dir/plutus-apps to tmp-plutus-apps/"
  mv "$dir"/plutus-apps tmp-plutus-apps/"$dir"
  rm -fr "$dir"
done
# Move the plutus-apps directories back to the parent directory
mv tmp-plutus-apps plutus-apps