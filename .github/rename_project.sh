
#!/usr/bin/env bash
while getopts a:n:u:d:p: flag
do
    case "${flag}" in
        a) author=${OPTARG};;
        n) name=${OPTARG};;
        u) urlname=${OPTARG};;
        d) description=${OPTARG};;
        p) prefix=${OPTARG};;
    esac
done

echo "Author: $author";
echo "Project Name: $name";
echo "Project URL name: $urlname";
echo "Description: $description";
echo "Prefix: $prefix";

#remove ui-plugin

pageName=$(sed -r 's/(ui-plugin-)(.*)/\2/g' <<< "$urlname")
cameCase=$(sed -r 's/(^|-)(\w)/\U\2/g' <<<"$pageName")
guid=$(cat /proc/sys/kernel/random/uuid)

echo "$cameCase $namespace $prefix"
echo "Renaming project..."

original_author="MatrixRequirements"
original_name="matrix-ui-plugin-boilerplate-24"
original_description=" matrix-ui-plugin-boilerplate-24 created by someone"
original_pageid="BPP"



 sed -i "s/$original_pageid/$prefix-$guid/g" "package.json"


for filename in $(git ls-files) 
do
    echo "Processing $filename"
   [[ $filename = .github* ]] &&  echo "Skipping $filename"
   [[ $filename != .github* ]] &&  sed -i "s/$original_name/$name/g" "$filename"
   [[ $filename != .github* ]] &&  sed -i "s/$original_author/$author/g" "$filename"
   [[ $filename != .github* ]] &&  sed -i "s/$original_description/$description/g" "$filename"
   [[ $filename != .github* ]] &&  sed -i "s/$original_pageid/$prefix/g" "$filename"
   [[ $filename != .github* ]] &&  echo "$filename fixed"
 done

cd src

git config --local user.email action@github.com
git config --local user.name GitHub Action
cd ..

git mv ./src/BPP ./src/$prefix-$guid

git rm .github/rename_project.sh
git rm .github/workflows/template.yaml

git commit -m "Rename template to project $cameCase" -a


# This command runs only once on GHA!
