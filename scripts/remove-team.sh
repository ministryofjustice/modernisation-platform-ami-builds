#!/bin/bash

read -p "Team name: " TEAM

rm -rf ../teams/${TEAM}

rm -f ../.github/workflows/${TEAM}_*.yml
