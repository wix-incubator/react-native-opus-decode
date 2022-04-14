#!/bin/bash -e

echo "Configuring git..."
remoteUrl=$(git remote get-url origin | sed 's/https:\/\///')
git config --global push.default simple
git config --global user.email $GIT_EMAIL
git config --global user.name $GIT_USER
git remote add deploy "https://$GIT_USER:$GIT_TOKEN@$remoteUrl"
git checkout $BUILDKITE_BRANCH
echo "//registry.npmjs.org/:_authToken=${NPM_TOKEN}" > .npmrc

normalized_branch=$(echo $BUILDKITE_BRANCH | sed 's/[^a-zA-Z0-9-]/./g')

if [ "$BUILDKITE_BRANCH" == "master" ];then
    npm version --no-git-tag-version patch
    npm publish
    git add package.json && git commit -m"$(npm view . version) [ci skip]" && git push deploy
    git push deploy
else
    npm version prerelease --preid $normalized_branch.$BUILDKITE_BUILD_NUMBER
    npm publish --tag build
fi

git remote remove deploy
