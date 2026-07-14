using Microsoft.AspNetCore.Mvc;

namespace SampleApi.Controllers;

[ApiController]
[Route("[controller]")]
public class ItemsController : ControllerBase
{
    private static readonly List<Item> _items =
    [
        new Item(1, "Widget",  9.99m),
        new Item(2, "Gadget", 24.99m),
        new Item(3, "Doohickey", 4.99m),
    ];

    [HttpGet]
    public IActionResult GetAll() => Ok(_items);

    [HttpGet("{id:int}")]
    public IActionResult GetById(int id)
    {
        var item = _items.FirstOrDefault(i => i.Id == id);
        return item is null ? NotFound() : Ok(item);
    }

    [HttpPost]
    public IActionResult Create([FromBody] CreateItemRequest request)
    {
        var item = new Item(_items.Count + 1, request.Name, request.Price);
        _items.Add(item);
        return CreatedAtAction(nameof(GetById), new { id = item.Id }, item);
    }
}

public record Item(int Id, string Name, decimal Price);
public record CreateItemRequest(string Name, decimal Price);
