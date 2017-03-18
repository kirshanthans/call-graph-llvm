; ModuleID = 'tc1.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: nounwind uwtable
define void @F() #0 {
entry:
  ret void
}

; Function Attrs: nounwind uwtable
define void @E() #0 {
entry:
  ret void
}

; Function Attrs: nounwind uwtable
define void @D() #0 {
entry:
  ret void
}

; Function Attrs: nounwind uwtable
define void @C() #0 {
entry:
  call void @D()
  call void @E()
  ret void
}

; Function Attrs: nounwind uwtable
define void @B() #0 {
entry:
  call void @C()
  ret void
}

; Function Attrs: nounwind uwtable
define void @A() #0 {
entry:
  call void @B()
  ret void
}

; Function Attrs: nounwind uwtable
define i32 @main() #0 {
entry:
  %p = alloca void (...)*, align 8
  call void @A()
  store void (...)* bitcast (void ()* @C to void (...)*), void (...)** %p, align 8
  %0 = load void (...)*, void (...)** %p, align 8
  call void (...) %0()
  ret i32 0
}

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (trunk 247717)"}
