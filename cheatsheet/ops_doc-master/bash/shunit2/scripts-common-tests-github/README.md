:warning: This project is now hosted on [Gitlab](https://gitlab.com/bertrand-benoit/scripts-common-tests); switch to it to get newer versions.

# scripts-common tester version 1.0
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/8b02d9867667402890608cc3e924abc3)](https://app.codacy.com/app/bertrand-benoit/scripts-common-tests?utm_source=github.com&utm_medium=referral&utm_content=bertrand-benoit/scripts-common-tests&utm_campaign=Badge_Grade_Dashboard)

[scripts-common](https://gitlab.com/bertrand-benoit/scripts-common) is a free common utilities/tool-box for GNU/Bash scripts, you can use for your own scripts.

This project aims to test it.

It was initially embedded in original repository.

It was then removed to avoid to be checkout in all client projects.

And eventually, it evolves to use [shUnit2](https://github.com/kward/shunit2).

## Usage
This version uses [shUnit2](https://github.com/kward/shunit2), so you cannot use CLI options; thus you must define the **SCRIPTS_COMMON_PATH** environment variable with the utilities version you want to test.
```
export SCRIPTS_COMMON_PATH="<path to define>/scripts-common/utilities.sh"
./tests.sh
```

## Contributing
Don't hesitate to [contribute](https://opensource.guide/how-to-contribute/) or to contact me if you want to improve the project.
You can [report issues or request features](https://gitlab.com/bertrand-benoit/scripts-common-tests/issues) and propose [merge requests](https://gitlab.com/bertrand-benoit/scripts-common-tests/merge_requests).

## Versioning
The versioning scheme we use is [SemVer](http://semver.org/).

## Authors
[Bertrand BENOIT](mailto:contact@bertrand-benoit.net)

## License
This project is under the GPLv3 License - see the [LICENSE](LICENSE) file for details
