package poker

import "testing"

func TestPointValid(t *testing.T) {
	t.Parallel()

	tests := map[string]struct {
		point Point
		want  bool
	}{
		"未指定":       {point: PointUnspecified, want: true},
		"0":         {point: Point0, want: true},
		"21":        {point: Point21, want: true},
		"コーヒー":      {point: PointCoffee, want: true},
		"クエスチョン":    {point: PointQuestion, want: true},
		"一覧に無い負の値":  {point: Point(-1), want: false},
		"一覧に無い中間の値": {point: Point(50), want: false},
		"一覧に無い大きい値": {point: Point(102), want: false},
	}

	for name, tt := range tests {
		t.Run(name, func(t *testing.T) {
			t.Parallel()

			if got := tt.point.Valid(); got != tt.want {
				t.Errorf("Point(%d).Valid() = %v, want %v", tt.point, got, tt.want)
			}
		})
	}
}

func TestBallotReset(t *testing.T) {
	t.Parallel()

	b := &Ballot{Point: Point8, Role: UserRoleVoter}
	b.Reset()

	if b.Point != PointUnspecified {
		t.Errorf("Reset() 後の Point = %d, want %d", b.Point, PointUnspecified)
	}
	if b.Role != UserRoleVoter {
		t.Errorf("Reset() は Role を変えない。got %d, want %d", b.Role, UserRoleVoter)
	}
}

func TestBallotIsObserver(t *testing.T) {
	t.Parallel()

	tests := map[string]struct {
		role UserRole
		want bool
	}{
		"未指定":    {role: UserRoleUnspecified, want: false},
		"投票者":    {role: UserRoleVoter, want: false},
		"オブザーバー": {role: UserRoleObserver, want: true},
	}

	for name, tt := range tests {
		t.Run(name, func(t *testing.T) {
			t.Parallel()

			b := &Ballot{Role: tt.role}
			if got := b.IsObserver(); got != tt.want {
				t.Errorf("IsObserver() = %v, want %v", got, tt.want)
			}
		})
	}
}

func TestBallotSetObserverMode(t *testing.T) {
	t.Parallel()

	t.Run("オブザーバーにすると投票がリセットされる", func(t *testing.T) {
		t.Parallel()

		b := &Ballot{Point: Point13, Role: UserRoleVoter}
		b.SetObserverMode(true)

		if b.Role != UserRoleObserver {
			t.Errorf("Role = %d, want %d", b.Role, UserRoleObserver)
		}
		if b.Point != PointUnspecified {
			t.Errorf("Point = %d, want %d", b.Point, PointUnspecified)
		}
	})

	t.Run("投票者に戻しても Point は据え置き", func(t *testing.T) {
		t.Parallel()

		b := &Ballot{Point: PointUnspecified, Role: UserRoleObserver}
		b.SetObserverMode(false)

		if b.Role != UserRoleVoter {
			t.Errorf("Role = %d, want %d", b.Role, UserRoleVoter)
		}
		if b.Point != PointUnspecified {
			t.Errorf("Point = %d, want %d", b.Point, PointUnspecified)
		}
	})
}
