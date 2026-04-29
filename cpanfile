requires 'DBI';

on 'develop' => sub {
    recommends 'DBD::SQLite';
    recommends 'DBD::mysql';
    recommends 'DBD::Pg';
    recommends 'DBD::ODBC';
    recommends 'DBD::Oracle';
};
