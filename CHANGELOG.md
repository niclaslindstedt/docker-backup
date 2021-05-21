# [1.1.0](https://github.com/niclaslindstedt/docker-backup/compare/v1.0.0...v1.1.0) (2021-05-21)


### Features

* Add options to create signatures of checksums ([#44](https://github.com/niclaslindstedt/docker-backup/issues/44)) ([2d87725](https://github.com/niclaslindstedt/docker-backup/commit/2d87725254e88fd571a63371c87f0535df57b31a))



# [1.0.0](https://github.com/niclaslindstedt/docker-backup/compare/v0.9.0...v1.0.0) (2021-05-20)


### Bug Fixes

* Change file ending of encrypted files to gpg ([#31](https://github.com/niclaslindstedt/docker-backup/issues/31)) ([26480aa](https://github.com/niclaslindstedt/docker-backup/commit/26480aa49a704f06254fc7747b61507e38b42007))
* Move backups to temporary folder before unpacking/decrypting ([#25](https://github.com/niclaslindstedt/docker-backup/issues/25)) ([c1d14c3](https://github.com/niclaslindstedt/docker-backup/commit/c1d14c3939361e76f7d69309c72628824d690c42))
* Restore now works multiple times on same backup ([#29](https://github.com/niclaslindstedt/docker-backup/issues/29)) ([2195cf3](https://github.com/niclaslindstedt/docker-backup/commit/2195cf314b06b9d8c9262dd63afca4f1a10a9097))


### Features

* Add alpine version of image ([#17](https://github.com/niclaslindstedt/docker-backup/issues/17)) ([d17c2c4](https://github.com/niclaslindstedt/docker-backup/commit/d17c2c42cd9bf93d9d5721543b1a77a54b4e65e6))
* Add support for pruning a specific volume ([#18](https://github.com/niclaslindstedt/docker-backup/issues/18)) ([8e81e33](https://github.com/niclaslindstedt/docker-backup/commit/8e81e33df47647b019b979988ce85467f438502f))
* Add support for storing a specific volume ([#19](https://github.com/niclaslindstedt/docker-backup/issues/19)) ([34f481c](https://github.com/niclaslindstedt/docker-backup/commit/34f481c8e7b03190f82b3f361985470fd5d0a1eb))
* Add support for verifying encryption ([#27](https://github.com/niclaslindstedt/docker-backup/issues/27)) ([f25bdcd](https://github.com/niclaslindstedt/docker-backup/commit/f25bdcd36e6d4144c411255c681df7fdf4a0fbef))
* Add support to restore directly from long-term storage ([#20](https://github.com/niclaslindstedt/docker-backup/issues/20)) ([6e882b8](https://github.com/niclaslindstedt/docker-backup/commit/6e882b812d41b1ca0ad024247b0e15fa97a9b487))
* Replace verbose mode with log levels ([#28](https://github.com/niclaslindstedt/docker-backup/issues/28)) ([fe0738f](https://github.com/niclaslindstedt/docker-backup/commit/fe0738f10e8d66ba82e1bd7182f990b7ec074bfb))
* Use file locks to prevent simultaneous actions ([#22](https://github.com/niclaslindstedt/docker-backup/issues/22)) ([267e6c9](https://github.com/niclaslindstedt/docker-backup/commit/267e6c92e13e92eebd701506039bd0059967dbc1))


### BREAKING CHANGES

* Backup files ending in .enc will no longer be recognized as encrypted backups, and will need to be renamed.



# 0.9.0 (2021-05-15)



