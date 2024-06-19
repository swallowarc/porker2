package user

import "regexp"

type Name string

var (
	nameRegexp = regexp.MustCompile(`^.{1,10}$`)
)

func (n Name) String() string {
	return string(n)
}

func (n Name) Valid() bool {
	return nameRegexp.MatchString(string(n))
}
