import graphene


class Car(graphene.ObjectType):
    name = graphene.String()

    def resolve_name(parent, info):
        return "hello"


class Query(graphene.ObjectType):
    cars = graphene.List(Car)

    def resolve_cars(parens, info):
        return [Car(), Car()]


schema = graphene.Schema(query=Query)
