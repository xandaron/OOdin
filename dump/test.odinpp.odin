package OdinPP


Test___init :: proc(this: ^Test, b: b32) {
	this.a = 10
	this.b = b
	this.c = 1.0
}

Test___uninit :: proc(this: ^Test) {
	return
}

Test___sub_a :: proc(this: ^Test, x: i32) -> i32 {
	return x - this.a
}Test :: struct {
	a: i32,
	b: b32,
	c: f32,
}

Class2 :: struct {}


new_class___init :: proc(this: ^new_class) {
	// Inherited constructors must be called explicitly.
	Test.init(3.5)
	Class2.init()
}new_class :: struct {
	using base___Test:   base___Test,
	using base___Class2: base___Class2,
}

// abs_class :: class #abstract {
// 	f1: f32,
// 	f2: i32,

// 	init :: proc(f1: f32, f2: i32) {
// 		this.f1 = f1
// 		this.f2 = f2
// 	},

// 	abs_method :: proc(),
// }


my_class___init :: proc(this: ^my_class) {
	abs_class.init(3.0, 20)
}

my_class___abs_method :: proc(this: ^my_class) {
	return this.f1 + this.f2
}my_class :: struct {
	using base___abs_class: base___abs_class,
}

// abs_2_class :: class #abstract #inherits(abs_class) {}

parapoly_class :: struct($T: typeid) {
	field1: T,
}

para_inheritor :: struct($T: typeid) {
	using base___parapoly_class: base___parapoly_class,
}

main :: proc() {
	t1: Test
	// t1.init(false)
	// defer t1.uninit()

	// t1.sub_a(10)

	t2: ^Test = new(Test)
	defer free(t2)
	// t2.init(false)
	// defer t2.uninit()

	t3: new_class
	t3.a = 2
	// t3.sub_a(5)

	parapoly: parapoly_class(i32)
}
