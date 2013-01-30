use inc::Module::Install;
name 'Test-LogFile';
all_from 'lib/Test/LogFile.pm';

requires 'File::Temp' => '0';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
WriteAll;
