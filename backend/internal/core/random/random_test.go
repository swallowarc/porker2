package random

import (
	"regexp"
	"sync"
	"testing"
)

func TestRandString6(t *testing.T) {
	actual := RandString6(6)
	if len(actual) != 6 {
		t.Errorf("expected %d, actual %d", 6, len(actual))
	}
	if !regexp.MustCompile(`^[a-zA-Z0-9]*$`).MatchString(actual) {
		t.Errorf("英数字以外の文字が混在")
	}
}

func TestRandString6_Concurrent(t *testing.T) {
	const (
		goroutines = 50
		iterations = 100
	)

	var wg sync.WaitGroup
	results := make([][]string, goroutines)
	for i := range goroutines {
		wg.Add(1)
		go func(i int) {
			defer wg.Done()

			got := make([]string, 0, iterations)
			for range iterations {
				got = append(got, RandString6(6))
			}
			results[i] = got
		}(i)
	}
	wg.Wait()

	pattern := regexp.MustCompile(`^[a-zA-Z0-9]{6}$`)
	uniq := make(map[string]struct{}, goroutines*iterations)
	for _, rs := range results {
		for _, s := range rs {
			if !pattern.MatchString(s) {
				t.Errorf("想定外の文字列が生成された: %q", s)
			}
			uniq[s] = struct{}{}
		}
	}

	// 62^6 の空間から 5,000 件を生成するため、重複はほぼ発生しない。
	// 乱数の状態が壊れると同じ文字列が量産されるため、閾値で検知する。
	const minUniq = goroutines * iterations * 99 / 100
	if len(uniq) < minUniq {
		t.Errorf("生成された文字列の重複が多すぎる: unique=%d, want>=%d", len(uniq), minUniq)
	}
}
