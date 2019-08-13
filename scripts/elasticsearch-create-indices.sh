#!/usr/bin/env bash


bundle exec rake environment elasticsearch:import:model CLASS=Statement SCOPE=published FORCE=y
bundle exec rake environment elasticsearch:import:model CLASS=Article SCOPE=published FORCE=y
bundle exec rake environment elasticsearch:import:model CLASS=Speaker FORCE=y
