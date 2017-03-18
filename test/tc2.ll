; ModuleID = 'tc2.c'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

%struct.s = type { void (...)*, i32 }

@.str = private unnamed_addr constant [20 x i8] c"f must be invoked!\0A\00", align 1
@s1 = common global %struct.s zeroinitializer, align 8

; Function Attrs: nounwind uwtable
define void @F() #0 {
entry:
  %call = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([20 x i8], [20 x i8]* @.str, i32 0, i32 0))
  ret void
}

declare i32 @printf(i8*, ...) #1

; Function Attrs: nounwind uwtable
define void @E() #0 {
entry:
  store void (...)* bitcast (void ()* @F to void (...)*), void (...)** getelementptr inbounds (%struct.s, %struct.s* @s1, i32 0, i32 0), align 8
  %0 = load void (...)*, void (...)** getelementptr inbounds (%struct.s, %struct.s* @s1, i32 0, i32 0), align 8
  call void (...) %0()
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
  call void @A()
  ret i32 0
}

attributes #0 = { nounwind uwtable "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="true" "no-frame-pointer-elim-non-leaf" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+sse,+sse2" "unsafe-fp-math"="false" "use-soft-float"="false" }

!llvm.ident = !{!0}

!0 = !{!"clang version 3.8.0 (trunk 247717)"}
