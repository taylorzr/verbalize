# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- changelog started
### Changed
- privatize Action.input. Now that we have Action.inputs, we want to avoid calling Action.input (no s) outside of the action itself

## 2.1.1 - 2017-02-21
### Fixed
- ensure Verbalize::Action.optional_input always returns an array

## 2.1.0 - 2017-02-21
### Added
- introspect Action input using Action.inputs, Action.required_inputs, and Action.optional_inputs

## 2.0.2 - 2017-2-21 [YANKED]
- new functionality was added, so minor version should have been increased instead of patch

## 2.0.1 - 2016-12-16
### Changed
- internal refactoring

## 2.0.0 - 2016-02-14
### Added
- execution of action routed through Action#perform to better support stubbing
- 100% test coverage!!!
### Changed
- calling Failure#value now raises an error, use Failure#failure instead? Did this happen in 1.3?
### Removed
- removes action implementation methods other than #call/#call!

## 1.4.1 - 2016-12-14
### Added
- Failure#failure added to replace Failure#value
### Changed
- Result split into Success/Failure
### Deprecated
- stop including Verbalize itself, use Verbalize::Action instead
- stop using action implementation methods other than #call/#call!
- stop using Failure#value, used Failure#failure instead

## 1.4.0 [YANKED] - 2016-12-14
### Fixed
- error while uploading to ruby gems, yanked and released v1.4.1

## 1.3.0 - 2016-11-09
### Changed
- better failure handling

## 1.2.0 - 2016-11-07
### Added
- alias Result.success? to Result.succeeded?
- alias Result.failure? to Result.failed?
### Changed
- Action now implements #to_ary instead of subclassing Array

## 1.1.2 - 2016-11-07 [YANKED]
- new functionality was added, so minor version should have been increased instead of patch

## 1.1.1 - 2016-08-25
### Changed
- internal refactoring

## 1.0.1 - 2016-08-10
### Fixed
- Use send to call Action#call so that Action#call can be privatized

## 1.0.0 - 2016-08-09
### Added
- optional input

## 0.1.0 - 2016-08-07
- initial release

