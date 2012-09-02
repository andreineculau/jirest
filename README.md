# jiREST

is a CLI for [Jira's REST API][^1] in Node.


# Setup

Install globally `npm install -g jirest`
or locally by setting the PATH `export PATH=./node_modules/bin;$PATH` and `npm install jirest`.

```bash
mkdir ~/.jirest
cp .jirest/config.sample.json ~/.jirest/config.json
nano ~/.jirest/config.json
```

Try it out with `jirest [someproject]-[someticketnumber]`.

If you want a different layout, `cp .jirest/* ~/.jirest/` and start playing with the templates in [eco][^2]


# Roadmap

* OAuth instead of cleartext user and pass `jirest auth user:password`

* Search for an issue `jirest (issue) search`
* *DONE* Read issue `jirest (issue) proj-5`
* *DONE* Open issue in browser `jirest proj-5 open`
* *DONE* Create branch name from issue `jirest proj-5 branch`
* Assign me to issue `jirest proj-5 assignme`

* Add comment to issue `jirest proj-5 comment 'lorem ipsum'`

* Search for a user `jirest user search`
* Read user `jirest user username`


[^1]: <http://docs.atlassian.com/jira/REST/latest/>
[^2]: <https://github.com/sstephenson/eco>
